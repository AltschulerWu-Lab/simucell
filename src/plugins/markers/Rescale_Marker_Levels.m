classdef Rescale_Marker_Levels <SimuCell_Marker_Operation
  %Rescale_Marker_Levels marker plugin used to rescale marker
  %linearly levels to lie within a specified range.
  %
  %Rescale_Marker_Levels Properties:
  %   min_intensity - Minimum Intensity After Rescaling
  %     Default value : 1
  %     Range value : 0 to 1
  %   max_intensity - Maximum Intensity After Rescaling
  %     Default value : 1
  %     Range value : 0 to 1
  %
  %Usage:
  %%Rescale Marker Level
  %op=Rescale_Marker_Levels();
  %
  %%Minimum Intensity After Rescaling
  %set(op,'min_intensity',0.5);
  %
  %%Maximum Intensity After Rescaling
  %set(op,'max_intensity',0.9);
  %
  %subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    min_intensity
    max_intensity
    description=['Rescale marker linearly levels to lie within'...
      ' a specified range'];
  end
  
  
  methods
    
    function obj=Rescale_Marker_Levels()
      obj.min_intensity=Parameter('Min',1,SimuCell_Class_Type.number,...
        [0,1],'Minimum Intensity After Rescaling');
      obj.max_intensity=Parameter('Max',1,SimuCell_Class_Type.number,...
        [0,1],'Maximum Intensity After Rescaling');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,...
        other_cells_mask,needed_shapes,needed_markers)
      present_min=min(current_marker(current_shape_mask));
      present_max=max(current_marker(current_shape_mask));
      result=current_marker;
      if(present_max~=present_min)
        result(current_shape_mask)=...
          (result(current_shape_mask)-present_min)/(present_max-present_min);
        result(current_shape_mask)=...
          result(current_shape_mask)*(obj.max_intensity.value-obj.min_intensity.value)...
          +obj.min_intensity.value;
      end
      result=max(min(result,1),0);
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list=cell(0);
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list=cell(0);
    end
    
  end
  
  
end