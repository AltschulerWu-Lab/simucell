classdef Nearby_Placement <SimuCell_Placement_Model
  %Nearby_Placement placement plugin used so cells are placed to be close to
  %existing cells.
  %
  %Nearby_Placement Properties:
  %   clustering_probability - Probability that a cell will be placed close
  %   to a cluster (otherwise position is random).
  %     Default value : 0.9
  %     Range value : 0 to 1
  %   distance_to_existing - Positions are selected with Poisson probability
  %   distributions with this mean distance.
  %     Default value : 200
  %     Range value : 1 to Inf
  %   boundary - Boundary Of Image Inside Which No Cells Will be Centered in
  %   pixels.
  %     Default value : 100
  %     Range value : 0 to Inf
  %
  %Usage:
  %%Set the Model Placement
  %%Placement refers to the position of cell in an image.
  %%Cells in different subpopulations can display different patterns of
  %%placement (e.g, one type of cells may be clustered or placed randomly)
  %%Placement for cells in a subpopulation are specified through the
  %%placement property in subpopulation, which you need to set the the
  %%appropriate placement model.
  %%Models for placements are classes of type SimuCell_Placement_Model,
  %%and are implemented via plugins (usually placed in the 
  %%'plugins/placement/' directory).
  %%Here we choose to have cells placed close to existing cells, and so
  %%choose the 'Nearby_Placement' model.
  %subpop{1}.placement=Nearby_Placement();
  %
  %%The placement models follow the typical model specification
  %%(see SimuCell_Model, Parameter), and the user settable parameters
  %%can be found in the plugin file. These parameters follow the standard
  %%set framework.
  %%For this model, probability of a pixel being picked is dependent on 
  %%its distance to the nearest existing cell. The functional form of this
  %%dependence is the probability density function of a poisson 
  %%distribution with mean specified by the 'distance_to_existing' below
  %set(subpop{1}.placement,'distance_to_existing',15);
  %
  %%The boundary is the number of pixels around the edge of the image
  %%where no cells are placed.
  %set(subpop{1}.placement,'boundary',100);
  %
  %%Probability that the cell is part of the cluster, non-clustered 
  %%cells are placed randomly.
  %set(subpop{1}.placement,'clustering_probability',0.8);
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    clustering_probability;
    distance_to_existing;
    boundary;
    description='Cells are placed to be close to existing cells';
  end
  
  
  properties (Access=private)
    cluster_positions
  end
  
  
  methods
    
    function obj=Nearby_Placement()
      obj.clustering_probability=Parameter('Clustering Probability',...
        0.9,SimuCell_Class_Type.number,[0,1],...
        'Probability that a cell will be placed close to other cells');
      obj.distance_to_existing=Parameter('Mean Distance To Existing',...
        200,SimuCell_Class_Type.number,[1,Inf],...
        ['Positions are selected with Poisson probability'...
        ' distributions with this mean distance']);
      obj.boundary=Parameter('Image Boundary',100,...
        SimuCell_Class_Type.number,[0,Inf],...
        'Boundary Of Image Inside Which No Cells Will be Centered');
    end
    
    function pos=pick_positions(obj,full_image_mask,current_cell_mask)
      [max_x,max_y]=size(full_image_mask);
      prob=rand();
      
      if(prob<obj.clustering_probability.value)
        if(nnz(full_image_mask)~=0)
          %Possible speed up using meshgrid and explicit calculation?
          dists=bwdist(full_image_mask);
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