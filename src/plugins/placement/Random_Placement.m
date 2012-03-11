classdef Random_Placement <SimuCell_Placement_Model

        properties
                description='Positions are picked Randomly In image avoiding a boundary region';
                boundary;
        end

        methods
                function obj=Random_Placement()
                        obj.boundary=Parameter('Image Boundary',100,SimuCell_Class_Type.number,...
                        [0,500],'Boundary Of Image Inside Which No Cells Will be Centered');
                end
                function pos=pick_positions(obj,full_image_mask,current_cell_mask);
                    [max_x,max_y]=size(full_image_mask);
                    
                    allowed_pixels=~full_image_mask;
                    allowed_pixels(1:obj.boundary.value,:)=false;
                    allowed_pixels(:,1:obj.boundary.value)=false;
                    allowed_pixels(max_x-obj.boundary.value+1:max_x,:)=false;
                    allowed_pixels(:,max_y-obj.boundary.value+1:max_y)=false;
                    pos=zeros(2,1);
                    if(nnz(allowed_pixels)~=0)
                        [pos(1),pos(2)]=ind2sub([max_x,max_y],randsample(find(allowed_pixels),1));
                    else
                        pos(1)=randi([obj.boundary.value,max_x-obj.boundary.value]);
                        pos(2)=randi([obj.boundary.value,max_y-obj.boundary.value]);
                        
                    end
                        
                        
                        
                end
        end

end
