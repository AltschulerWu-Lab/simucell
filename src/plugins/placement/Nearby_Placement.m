classdef Nearby_Placement <SimuCell_Placement_Model
    
    properties
      
       
        distance_to_existing;
        boundary;
        clustering_probability;
        description='Cells are placed to be close to existing cells';
        
    end
    
    properties (Access=private)
        cluster_positions
    end
    
    methods
        function obj=Nearby_Placement()
           
            obj.clustering_probability=Parameter('Clustering Probability',0.9,SimuCell_Class_Type.number,...
                [0,1],'Probability that a cell will be placed close to other cells');
            obj.distance_to_existing=Parameter('Mean Distance To Existing',200,SimuCell_Class_Type.number,...
                [1,Inf],'Positions are selected with Poisson probability distributions with this mean distance');
            obj.boundary=Parameter('Image Boundary',100,SimuCell_Class_Type.number,...
                [0,Inf],'Boundary Of Image Inside Which No Cells Will be Centered');
            
        end
        function pos=pick_positions(obj,full_image_mask,current_cell_mask);
            [max_x,max_y]=size(full_image_mask);
            
            
            prob=rand();
            
            if(prob<obj.clustering_probability.value)
                
                
                if(nnz(full_image_mask)~=0)
                    dists=bwdist(full_image_mask);%% Possible speed up using meshgrid and explicit calculation?
                    dists=poisspdf(dists,obj.distance_to_existing.value);
                    dists(full_image_mask)=0;
                else
                   dists=ones([max_x,max_y]) ;
                end
                
                %Disallowed regions
                
                dists(1:obj.boundary.value,:)=0;
                dists(:,1:obj.boundary.value)=0;
                dists(max_x-obj.boundary.value+1:max_x,:)=0;
                dists(:,max_y-obj.boundary.value+1:max_y)=0;
                
                %Generate points with given probability
                
                probs=dists(:)/sum(dists(:));
                chosen_pixel=discrete_prob(probs');
                [x,y]=ind2sub([max_x,max_y],chosen_pixel);
                pos=[x,y];
                
            else
                temp_img=true(max_x,max_y);
                temp_img(full_image_mask)=false;
                temp_img(1:obj.boundary.value,:)=false;
                temp_img(:,1:obj.boundary.value)=false;
                temp_img(max_x-obj.boundary.value+1:max_x,:)=false;
                temp_img(:,max_y-obj.boundary.value+1:max_y)=false;
                available_pixels=find(temp_img);
                chosen_pixel=randsample(available_pixels,1);
                [x,y]=ind2sub([max_x,max_y],chosen_pixel);
                pos=[x,y];
            end
            
            
            
        end
        
       
    end
    
end
