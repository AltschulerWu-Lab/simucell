classdef Lipid_Droplet_Model <SimuCell_Object_Model
  %Lipid_Droplet_Model shape model plugin modeling lipid droplets
  %(radius, number and arrangement (i.e. clustered or not) can be
  %specified).
  %
  %Lipid_Droplet_Model Properties:
  %   droplet_radius - Radius (in pixels) of lipid droplets
  %     Default value : 3
  %     Range value : 0 to Inf
  %   number_of_droplets - Average number of droplets
  %     Default value : 5
  %     Range value : 0 to Inf
  %   number_of_clusters - 0- random placement, otherwise number of droplet
  %   clusters
  %     Default value : 0
  %     Range value : 0 to Inf
  %   cytoplasm - Droplets will be placed inside this shape
  %     Default value : -
  %   cytoplasm - Droplets will avoid this shape
  %     Default value : -
  %
  %Usage:
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    droplet_radius;
    number_of_droplets;
    number_of_clusters;
    cytoplasm;
    nucleus;
    description=['Lipid Droplets: Radius, number and arrangement'...
      ' (i.e. clustered or not) can be specified'];
  end
  
  
  methods
    
    function obj=Lipid_Droplet_Model()
      obj.droplet_radius=Parameter('Lipid Droplet Radius',3,SimuCell_Class_Type.number,...
        [0,Inf],'Radius (in pixels) of lipid droplets');
      obj.number_of_droplets=Parameter('Number of Lipid Droplets',5,SimuCell_Class_Type.number,...
        [0,Inf],'Average number of droplets');
      obj.number_of_clusters=Parameter('Number of Clusters',0,SimuCell_Class_Type.number,...
        [0,Inf],'0- random placement, otherwise number of droplet clusters');
      obj.cytoplasm=Parameter('Cytoplasm',[],SimuCell_Class_Type.simucell_shape_model,...
        [],'Droplets will be placed inside this shape');
      obj.nucleus=Parameter('Nucleus',[],SimuCell_Class_Type.simucell_shape_model,...
        [],'Droplets will avoid this shape');
    end
    
    function droplet_shape=make_shape(obj,pos,current_image_mask,prerendered_shapes)
      cyto_shape=prerendered_shapes{1};
      nuclear_shape=prerendered_shapes{2};
      droplet_shape=false(size(cyto_shape));
      nd=obj.number_of_droplets.value;
      %nd=poissrnd(obj.number_of_droplets);
      max_failures=30;
      if(obj.number_of_clusters.value>0)
        cluster_locations=zeros(obj.number_of_clusters.value,2);
        mask=(~cyto_shape | nuclear_shape | droplet_shape);
        viable_spots=find(bwdist(mask)>obj.droplet_radius.value+3);
        if(isempty(viable_spots))
          return;
        else
          pos=randsample(viable_spots,1);
        end
        [pos_x,pos_y]=ind2sub(size(droplet_shape),pos);
        cluster_locations(1,:)=[pos_x,pos_y];
        temp=false(size(cyto_shape));
        temp1=false(size(cyto_shape));
        temp(pos_x,pos_y)=true;
        temp1(viable_spots)=true;
        for clust_num=1:obj.number_of_clusters.value-1
          dists=bwdist(temp);%Can be speeded up significantly
          dists(~temp1)=-1;
          [~,I]=max(dists(:));
          temp(I)=true;
          [cluster_locations(clust_num+1,1) cluster_locations(clust_num+1,2)]...
            =ind2sub(size(droplet_shape),I);
        end
        droplet_shape_cluster=false(size(cyto_shape,1),size(cyto_shape,1),obj.number_of_clusters.value);
        cluster_counts=zeros(obj.number_of_clusters.value,1);
        number_of_failures=0;
        %drops=poissrnd(obj.droplet_radius.value,nd,1);
        drops=obj.droplet_radius.value*ones(nd,1);
        target_area=pi*sum(drops.^2);
        area=0;
        while(area<target_area&&number_of_failures<max_failures)
          chosen_cluster=randsample(obj.number_of_clusters.value,1);
          cluster_counts(chosen_cluster)=cluster_counts(chosen_cluster)+1;
          mask=(~cyto_shape | nuclear_shape | droplet_shape);
          radius=obj.droplet_radius.value ;
          %radius=poissrnd(obj.droplet_radius.value);
          viable_spots=find(bwdist(mask)>max(radius+3,1));%% Gap b/w droplets added by hand
          if(isempty(viable_spots))
            number_of_failures=number_of_failures+1;
            if(number_of_failures>max_failures)
              disp('LD problem');
              return;
            end
            break;
          else
            if(cluster_counts(chosen_cluster)>1)
              dists=bwdist(squeeze(droplet_shape_cluster(:,:,chosen_cluster)));
              dists=dists+rand(size(cyto_shape));
              temp=false(size(cyto_shape));
              temp(viable_spots)=true;
              dists(~temp)=10000;
              [~,pos]=min(dists(:));
              [pos_x,pos_y]=ind2sub(size(droplet_shape),pos);
            else
              pos_x=cluster_locations(chosen_cluster,1);
              pos_y=cluster_locations(chosen_cluster,2);
            end
            for x1=(pos_x-radius):(pos_x+radius)
              if((x1>0) && (x1<= size(droplet_shape,1)))
                for y1=(pos_y-radius):(pos_y+radius)
                  if((y1>0) && (y1<= size(droplet_shape,2)))
                    if(sqrt((pos_x-x1)^2+(pos_y-y1)^2)<=radius)
                      droplet_shape(x1,y1)=true;
                      droplet_shape_cluster(x1,y1,chosen_cluster)=true;
                    end
                  end
                end
              end
            end
            area=nnz(droplet_shape);
          end
        end
      else
        number_of_failures=0;
        %drops=poissrnd(obj.droplet_radius.value,nd,1);
        drops=obj.droplet_radius.value*ones(nd,1);
        target_area=pi*sum(drops.^2);
        area=0;
        while(area<target_area&&number_of_failures<max_failures)
          mask=(~cyto_shape | nuclear_shape | droplet_shape);
          radius=obj.droplet_radius.value;
          %radius=poissrnd(obj.droplet_radius.value);
          [xvals,yvals]=find(cyto_shape);
          region_to_consider=false(size(cyto_shape));
          x1=max(min(xvals)-radius,1);
          x2=min(max(xvals)+radius,size(cyto_shape,1));
          y1=max(min(yvals)-radius,1);
          y2=min(max(yvals)+radius,size(cyto_shape,2));
          region_to_consider(x1:x2,y1:y2)=bwdist(mask(x1:x2,y1:y2))>radius+3; %Gap b/w drops
          viable_spots=find(region_to_consider);
          %viable_spots=find(bwdist(mask)>radius);
          if(isempty(viable_spots))
            number_of_failures=number_of_failures+1;
            if(number_of_failures>max_failures)
              disp('LD problem');
              return;
            end
          else
            pos=randsample(viable_spots,1);
            if(~cyto_shape(pos))
              return;
            end
            [pos_x,pos_y]=ind2sub(size(droplet_shape),pos);
            for x1=(pos_x-radius):(pos_x+radius)
              if((x1>0) && (x1<= size(droplet_shape,1)))
                for y1=(pos_y-radius):(pos_y+radius)
                  if((y1>0) && (y1<= size(droplet_shape,2)))
                    if(sqrt((pos_x-x1)^2+(pos_y-y1)^2)<=radius)
                      droplet_shape(x1,y1)=true;
                    end
                  end
                end
              end
            end
          end
          area=nnz(droplet_shape);
        end
      end
    end
    
    function pre_obj_list=prerendered_object_list(obj)
      pre_obj_list={obj.cytoplasm.value,obj.nucleus.value};
    end
    
  end
  
  
end
