classdef Constant_marker_level_operation <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        level
        description='Constant Marker Level';
    end
    
    methods
        function obj=Constant_marker_level_operation()
            obj.level=Parameter('Marker Level',0.5,SimuCell_Class_Type.number,...
                [0,1],'Marker Level[0-low, 1-High]');
           
        end
        
        
        
        function result=Apply(obj,x)
            result=x+obj.level;
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end