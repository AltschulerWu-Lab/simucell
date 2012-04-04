classdef Random_Placement <SimuCell_Placement_Model
  %Random_Placement placement plugin used so position cells randomly in image
  %but avoiding a boundary region.
  %
  %Random_Placement Properties:
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
  %%Models for placements are classes of type SimuCell_Placement_Model, and
  %%are implemented via plugins (usually placed in the 'plugins/placement/'
  %%directory).
  %%Here we choose to have cells placed close to existing cells, and so
  %%choose the 'Random_Placement' model.
  %subpop{1}.placement=Random_Placement();
  %
  %%The boundary is the number of pixels around the edge of the image where
  %%no cells are placed.
  %set(subpop{1}.placement,'boundary',100);
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    description='Positions are picked randomly in image avoiding a boundary region';
    boundary;
  end
  
  
  methods
    
    function obj=Random_Placement()
      obj.boundary=Parameter('Image Boundary',100,SimuCell_Class_Type.number,...
        [0,Inf],'Boundary Of Image Inside Which No Cells Will be Centered');
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