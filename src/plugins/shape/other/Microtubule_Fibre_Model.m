classdef Microtubule_Fibre_Model <SimuCell_Object_Model
  %Microtubule_Fibre_Model shape model plugin modeling microtubule fibre
  %
  %Microtubule_Fibre_Model Properties:
  %   number_of_threads - Number of threads
  %     Default value : 100
  %     Range value : 1 to Inf
  %   persistance_length - Distance (in pixels) between splits
  %     Default value : 3
  %     Range value : 1 to Inf
  %   dist_outside - Distance outside
  %     Default value : 0
  %     Range value : 0 to Inf
  %   fraction_allowed_outside - Fraction allowed outside
  %     Default value : 0
  %     Range value : 0 to 1
  %   cytoplasm - Microtubule Fibre will be placed inside this shape
  %     Default value : -
  %   cytoplasm - Microtubule Fibre will avoid this shape
  %     Default value : -
  %
  %Usage:
  %add_object(subpop{1},'fiber');
  %subpop{1}.objects.fiber.model=Microtubule_Fibre_Model;
  %set(subpop{1}.objects.fiber.model,'nucleus',subpop{1}.objects.nucleus,...
  %    'cytoplasm',subpop{1}.objects.cytoplasm);
  %
  % ------------------------------------------------------------------------------
  % Copyright ©2012, The University of Texas Southwestern Medical Center 
  % Authors:
  % Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
  % For latest updates, check: < http://www.SimuCell.org >.
  %
  % All rights reserved.
  % This program is free software: you can redistribute it and/or modify
  % it under the terms of the GNU General Public License as published by
  % the Free Software Foundation, version 3 of the License.
  %
  % This program is distributed in the hope that it will be useful,
  % but WITHOUT ANY WARRANTY; without even the implied warranty of
  % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  % GNU General Public License for more details:
  % < http://www.gnu.org/licenses/ >.
  %
  % ------------------------------------------------------------------------------
  %%
  
    
  
  properties    
    number_of_threads
    persistance_length
    dist_outside
    fraction_allowed_outside
    cytoplasm;
    nucleus;
    description='Microtubule Fibre';
  end
  
  
  methods
    
    function obj=Microtubule_Fibre_Model()
      obj.number_of_threads=Parameter('Number of threads',100,SimuCell_Class_Type.number,...
        [1,Inf],'Number of threads');
      obj.persistance_length=Parameter('Distance between splits',3,SimuCell_Class_Type.number,...
        [1,Inf],'Distance (in pixels) between splits');
      obj.dist_outside=Parameter('Distance outside',0,SimuCell_Class_Type.number,...
        [0,Inf],'Distance outside');
      obj.fraction_allowed_outside=Parameter('Fraction allowed outside',0,SimuCell_Class_Type.number,...
        [0,1],'Fraction allowed outside');
      obj.cytoplasm=Parameter('Cytoplasm',[],SimuCell_Class_Type.simucell_shape_model,...
        [],'Microtubule Fibre will be placed inside this shape');
      obj.nucleus=Parameter('Nucleus',[],SimuCell_Class_Type.simucell_shape_model,...
        [],'Microtubule Fibre will avoid this shape');
    end
    
    function fibre=make_shape(obj,pos,current_image_mask,prerendered_shapes)
      cyto_shape=(prerendered_shapes{1});
      nuclear_shape=(prerendered_shapes{2});
      image_size=size(cyto_shape);
      temp=bwdist(~cyto_shape);
      dist_to_cell=bwdist(cyto_shape);
      [gx,gy]=gradient(-temp);
      grad=(gx.^2+gy.^2);
      %grad1=grad(current_cell{obj.cytoplasmic_channel});
      %threshold=prctile(grad1(:),10);
      %[startx,starty]=find((grad>threshold)&cyto_shape);
      [startx,starty]=find(edge(nuclear_shape));
      %             [startx,starty]=find(~nuclear_shape&cyto_shape);
      if(isempty(obj.number_of_threads.value))
        obj.number_of_threads.value=round(nnz(cyto_shape)/10);
      end
      number_of_nodes=300;
      fibre=false(image_size);
      fibre_threads=cell(0);
      for thread_num=1:obj.number_of_threads.value
        i=randi(length(startx));
        x=startx(i);
        y=starty(i);
        within_bounds=true;
        node_num=1;
        thread=[];
        while (within_bounds&&node_num<number_of_nodes)
          %x1=round(x-10*gx(x+randi(10)-5,y+randi(10)-5)/(grad(x,y)+0.001)+2*randn);
          %y1=round(y-10*gy(x+randi(10)-5,y+randi(10)-5)/(grad(x,y)+0.001)+2*randn);
          rx=max(min(x+randi(10)-5,image_size(1)),1);
          ry=max(min(y+randi(10)-5,image_size(2)),1);
          x1=round(x-obj.persistance_length.value*gx(rx,ry)/(grad(x,y)+0.001)+5*randn);
          y1=round(y-obj.persistance_length.value*gy(rx,ry)/(grad(x,y)+0.001)+5*randn);
          if((x1>=1)&&(x1<image_size(1))&&(y1>=1)...
              &&(y1<image_size(2))&&~nuclear_shape(x1,y1))
            p=rand();
            if(cyto_shape(x1,y1)||...
                (dist_to_cell(x1,y1)<obj.dist_outside.value&&...
                p<obj.fraction_allowed_outside.value))
              l=line_points(x,y,x1,y1,image_size);
              if((nnz(nuclear_shape(l))==0))
                if(~cyto_shape(x1,y1)) %&&()
                  thread=[thread l'];
                  fibre(l)=true;
                  x=x1;
                  y=y1;
                  node_num=node_num+1;
                else
                  if(nnz(~cyto_shape(l))==0)
                    thread=[thread l'];
                    fibre(l)=true;
                    x=x1;
                    y=y1;
                    node_num=node_num+1;
                  else
                    within_bounds=false;
                  end
                end
              else
                within_bounds=false;
              end
            else
              within_bounds=false;
            end
          else
            within_bounds=false;
          end
        end
        if(~isempty(thread))
          fibre_threads{length(fibre_threads)+1}=thread;
        end
      end
      fibre(nuclear_shape)=false;
    end
    
    function pre_obj_list=prerendered_object_list(obj)
      pre_obj_list={obj.cytoplasm.value,obj.nucleus.value};
    end
    
  end
  
  
end
