classdef default_compositing<SimuCell_compositing_model
    
    properties
        description ='Shape masks are used to check if certain objects contain other objects. For objects that do not contain each other, their levels are averaged. If object A contains object B, then the weightage of A and B can be specified';
        container_weight
    end
    
    methods
        function obj=default_compositing()
            obj.container_weight=Parameter('Weight Given To Container',0,SimuCell_Class_Type.number,...
                [0,1],'When one object contains another, then on the contained object, the container will be given this weight, while the contained is given 1- this weight');
        end
        
        function object_compositing_matrix=calculate_compositing_matrix(obj,object_masks)
            [number_of_cells,number_of_objects]=size(object_masks);
            object_compositing_matrix=0.5*ones(number_of_objects);
            for obj1=1:number_of_objects
               for obj2=1:number_of_objects
                   is_contained=true;
                   for cell_number=1:number_of_cells
                       if(nnz((~object_masks{cell_number,obj1})&object_masks{cell_number,obj2})>0)
                           is_contained=false;
                       end
                   end
                   if(is_contained)
                      object_compositing_matrix(obj1,obj2)=obj.container_weight.value;
                      object_compositing_matrix(obj2,obj1)=1-obj.container_weight.value;
                   end
               end
            end
            
        end
        
%         function obj_list=object_list(obj)
%             
%         end
    end
end