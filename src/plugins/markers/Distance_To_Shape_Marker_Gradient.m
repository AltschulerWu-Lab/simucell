classdef Distance_To_Shape_Marker_Gradient <SimuCell_Marker_Operation
  %Distance_To_Shape_Marker_Gradient marker plugin used to scale marker
  %level based on distance to other objects
  %
  %Distance_To_Shape_Marker_Gradient Properties:
  %   distance_to - Marker levels are scaled based on distance to this shape
  %     Default value : -
  %   falloff_radius - Distance over which intensity falls off
  %   characteristically (e.g. 1/e)
  %     Default value : 10
  %     Range value : 0 to Inf
  %   falloff_type - Functional form to calculate level fall-off
  %     Default value : 'Gaussian'
  %     Available values : 'Linear','Gaussian','Exponential'
  %   increasing_or_decreasing - Increasing or Decreasing function of
  %   distance to edge
  %     Default value : 'Increasing'
  %     Available values : 'Increasing','Decreasing'
  %
  %Usage:
  %%We want the first marker to essentially cluster near the center of the
  %%cell, and die out before the edge of the cell. Since the cells in this
  %%subpopulation are spherical, this can be
  %%parametrized in terms of the distance to the nucleus.
  %%Add Radial Gradient (scaling of intensity at a pixel decreases with
  %%distance of that pixel to the nucleus)
  %op=Distance_To_Shape_Marker_Gradient();
  %
  %%The number of pixels over which intensity falls by 1/e
  %set(op,'falloff_radius',10);
  %
  %%The intensity fall off functional form
  %set(op,'falloff_type','Gaussian');
  %%Whether intensity increases or decreases based on the distance
  %set(op,'increasing_or_decreasing','Decreasing');
  %
  %%Distance is measure wrt the nucleus
  %set(op,'distance_to',subpop{1}.objects.nucleus);
  %subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    distance_to
    falloff_radius
    falloff_type
    increasing_or_decreasing
    description='Scale marker level based on distance to other objects';
  end
  
  
  methods
    
    function obj=Distance_To_Shape_Marker_Gradient()
      obj.distance_to=Parameter('Distance To',0,...
        SimuCell_Class_Type.simucell_shape_model,...
        [],'Marker levels are scaled based on distance to this shape');
      obj.falloff_radius=Parameter('Fall Off Radius',10,...
        SimuCell_Class_Type.number, [0,Inf],...
        'Distance over which intensity falls off characteristically (e.g. 1/e)');
      obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',...
        SimuCell_Class_Type.list, {'Linear','Gaussian','Exponential'},...
        'Functional form to calculate level fall-off');
      obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing',...
        'Increasing',SimuCell_Class_Type.list,{'Increasing','Decreasing'},...
        'Increasing or Decreasing function of distance to edge');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
      distance_to_mask=needed_shapes{1};
      selected_region_mask=(current_shape_mask|distance_to_mask);
      se=strel('disk',2,8);
      [row,col]=find(imdilate(full(selected_region_mask),se));
      selected_region=current_marker(min(row):max(row),min(col):max(col));
      selected_current_shape_mask=current_shape_mask(min(row):max(row),min(col):max(col));
      selected_distance_to_mask=distance_to_mask(min(row):max(row),min(col):max(col));
      z=bwdist(full(selected_distance_to_mask));
      switch obj.falloff_type.value
        case 'Linear'
          z=max(min(1-z/obj.falloff_radius.value,1),0);
          %z=max(1-obj.falloff_coefficient.value*z/radius,0);
        case 'Gaussian'
          z=exp(-(z/obj.falloff_radius.value).^2);
          %z=exp(-obj.falloff_coefficient.value*z.^2/((radius)^2));
        case 'Exponential'
          z=exp(-(z/obj.falloff_radius.value));
          %z=exp(-obj.falloff_coefficient.value*z/radius);
      end
      if(strcmp(obj.increasing_or_decreasing.value,'Increasing'))
        z=1-z;
      end
      selected_region=max(min(full(selected_region).*z,1),0);
      result=current_marker;
      result(current_shape_mask)=selected_region(selected_current_shape_mask);
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list=cell(0);
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list={obj.distance_to.value};
    end
    
  end
  
  
end
