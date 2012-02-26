classdef Clustered_Placement <SimuCell_Placement_Model
    
    properties
        number_of_clusters;
        clustering_probability;
        cluster_width;
        boundary;
        
        description='Cells are placed to form clusters';
        
    end
    
    properties (Access=private)
        cluster_positions
    end
    
    methods
        function obj=Clustered_Placement()
            obj.number_of_clusters=Parameter('Number Of Clusters',2,SimuCell_Class_Type.number,...
                [0,500],'Number Of Clusters Of Cells in Image');
            obj.clustering_probability=Parameter('Clustering Probability',0.9,SimuCell_Class_Type.number,...
                [0,1],'Probability that a cell will be placed close to a cluster (otherwise position is random)');
            obj.cluster_width=Parameter('Cluster Width',200,SimuCell_Class_Type.number,...
                [1,Inf],'Positions are selected with gaussian probability distributions of this width centered at the clusters');
            obj.boundary=Parameter('Image Boundary',100,SimuCell_Class_Type.number,...
                [0,Inf],'Boundary Of Image Inside Which No Cells Will be Centered');
            obj.cluster_positions=rand(obj.number_of_clusters.value,2);
            addlistener(obj.number_of_clusters,'Parameter_Set',@obj.update_cluster_positions);
            %addlistener(obj.clustering_probability,'Parameter_Set',@obj.update_cluster_positions);
            %             addlistener(obj.boundary,'Parameter_Set',@obj.update_cluster_positions);
        end
        function pos=pick_positions(obj,full_image_mask,current_cell_mask);
            [max_x,max_y]=size(full_image_mask);
            
            
            prob=rand();
            
            if(prob<obj.clustering_probability.value)
                clusternum=randi(obj.number_of_clusters.value);
                cx=round(obj.boundary.value+obj.cluster_positions(clusternum,1)*(max_x-2*obj.boundary.value));
                cy=round(obj.boundary.value+obj.cluster_positions(clusternum,2)*(max_y-2*obj.boundary.value));
                
                temp_img=false(max_x,max_y);
                temp_img(cx,cy)=true;
                dists=bwdist(temp_img);%% Possible speed up using meshgrid and explicit calculation?
                
                %Disallowed regions
                dists(full_image_mask)=Inf;
                dists(1:obj.boundary.value,:)=Inf;
                dists(:,1:obj.boundary.value)=Inf;
                dists(max_x-obj.boundary.value+1:max_x,:)=Inf;
                dists(:,max_y-obj.boundary.value+1:max_y)=Inf;
                
                %Generate points with given probability
                probs=exp(-dists.^2/obj.cluster_width.value^2);
                probs=probs(:)/sum(probs(:));
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
        
        function obj=update_cluster_positions(obj,passed_variable,passed_event)
            
            obj.cluster_positions=rand(obj.number_of_clusters.value,2);
            disp('cluster positions selected');
        end
        
    end
    
end
