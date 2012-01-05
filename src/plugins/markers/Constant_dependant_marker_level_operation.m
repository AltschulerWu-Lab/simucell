classdef Constant_dependant_marker_level_operation <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        slope
        intercept
        marker
        region
        func
        description='crap';
%         description=['Constant marker level with value ' ...
%         ' dependant (linearly) on the marker level of a chosen marker on a specified region.' ...
%         ' The new marker level is slope*F(marker_shape|region)+intercept, where' 
%         'F is the function (mean,median etc) calculated on marker_shape restricted to region' ...
%         ' Note: value will be clipped to lie between 0 and 1'];
        
    end
    
    methods
        function obj=Constant_dependant_marker_level_operation()
            obj.slope=Parameter('Slope',1,SimuCell_Class_Type.number,...
                [-Inf,Inf],'Slope of linear transform');
            obj.intercept=Parameter('Intercept',0,SimuCell_Class_Type.number,...
                [-Inf,Inf],'Intercept of linear transform');
           obj.marker=Parameter('Marker',0,SimuCell_Class_Type.simucell_marker_model,...
                [],'Chosen Marker (on shape)');
            obj.region=Parameter('Region',0,SimuCell_Class_Type.simucell_marker_model,...
                [],'Region on which marker is calculated');
            obj.func=Parameter('Function','Mean',SimuCell_Class_Type.simucell_marker_model,...
                {'Mean','Median','Max','Min'},'Function calculated on specified marker over specified region. Returns a single number');
        end
        
        
        
        function result=Apply(obj,x)
            result=x+obj.level;
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list={obj.marker.value};
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list={obj.region.value};
        end
       
    end
end