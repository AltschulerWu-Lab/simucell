classdef Rescale_marker_levels_operation <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        max_intensity
        min_intensity
        
        description='Rescale marker linearly levels to lie within a specified range';
        
    end
    
    methods
        function obj=Rescale_marker_levels_operation()
            obj.min_intensity=Parameter('Min',1,SimuCell_Class_Type.number,...
                [0,1],'Minimum Intensity After Rescaling');
            obj.max_intensity=Parameter('Max',1,SimuCell_Class_Type.number,...
                [0,1],'Maximum Intensity After Rescaling');
           
          
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
           
            
            present_min=min(current_marker(current_shape_mask));
            present_max=max(current_marker(current_shape_mask));
            
            result=current_marker;
            if(present_max~=present_min)
                result(current_shape_mask)=(result(current_shape_mask)-present_min)/(present_max-present_min);
                result(current_shape_mask)=result(current_shape_mask)*(obj.max_intensity.value-obj.min_intensity.value)...
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