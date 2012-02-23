classdef Microtubule_fibre_model <SimuCell_Object_Model
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        number_of_threads
        persistance_length
        dist_outside
        fraction_allowed_outside
        cytoplasm;
        nucleus;
        description='Lipid Droplets: Radius, number and arrangement (i.e. clustered or not) can be specified';
        
    end
    
    
    
    methods
        function obj=Microtubule_fibre_model()
            obj.number_of_threads=Parameter('Number of threads',100,SimuCell_Class_Type.number,...
                [1,Inf],'Radius (in pixels) of lipid droplets');
            obj.persistance_length=Parameter('Distance between splits',3,SimuCell_Class_Type.number,...
                [1,Inf],'Radius (in pixels) of lipid droplets');
            obj.dist_outside=Parameter('Number of lipid droplets',0,SimuCell_Class_Type.number,...
                [0,Inf],'Average Number of droplets ');
            obj.fraction_allowed_outside=Parameter('Number of clusters',0,SimuCell_Class_Type.number,...
                [0,1],'0- random placement, otherwise number of droplet clusters');
            obj.cytoplasm=Parameter('Cytoplasm',[],SimuCell_Class_Type.simucell_shape_model,...
                [],'Droplets will be placed inside this shape');
            obj.nucleus=Parameter('Nucleus',[],SimuCell_Class_Type.simucell_shape_model,...
                [],'Droplets will avoid this shape');
            
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
