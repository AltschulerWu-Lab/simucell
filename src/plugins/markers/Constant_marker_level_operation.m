classdef Constant_marker_level_operation <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mean_level
        sd_level
        description='Constant Marker Level. This level is sampled from a Normal Distribution with Specified Mean and Standard Deviation';
    end
    
    methods
        function obj=Constant_marker_level_operation()
            obj.mean_level=Parameter('Mean Marker Level',0.5,SimuCell_Class_Type.number,...
                [0,1],'Mean Marker Level[0-low, 1-High]');
            obj.sd_level=Parameter('Marker Level Sigma',0.2,SimuCell_Class_Type.number,...
                [0,Inf],'Standard Deviation [0- all cells have same level, Inf- uniform sampling]');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            chosen_level=obj.mean_level.value+obj.sd_level.value*randn();
            current_marker(current_shape_mask)=max(0,min(1,chosen_level));
            result=current_marker;
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end