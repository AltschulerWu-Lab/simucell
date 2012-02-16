classdef Constant_dependant_marker_level_operation <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        slope
        intercept
        marker
        region
        func
        description=['Constant marker level', ...
         ' dependant (linearly) on level of chosen marker on a specified region.', ...
        ' Output level is slope*F(marker_shape|region)+intercept. ', ... 
         'F is the function (mean,median etc) calculated on marker restricted to region'
         ];
        
    end
    
    methods
        function obj=Constant_dependant_marker_level_operation()
            obj.slope=Parameter('Slope',1,SimuCell_Class_Type.number,...
                [-Inf,Inf],'Slope of linear transform');
            obj.intercept=Parameter('Intercept',0,SimuCell_Class_Type.number,...
                [-Inf,Inf],'Intercept of linear transform');
           obj.marker=Parameter('Marker',0,SimuCell_Class_Type.simucell_marker_model,...
                [],'Chosen Marker (on shape)');
            obj.region=Parameter('Region',0,SimuCell_Class_Type.simucell_shape_model,...
                [],'Region on which marker is calculated');
            obj.func=Parameter('Function','Mean',SimuCell_Class_Type.list,...
                {'Mean','Median','Max','Min'},'Function calculated on specified marker over specified region. Returns a single number');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            shape_mask=needed_shapes{1};
            other_marker=needed_markers{1};
            masked_marker=other_marker(shape_mask);
            switch obj.func.value
                case 'Mean'
                    level=mean(masked_marker(:));
                case 'Median'
                   level=median(masked_marker(:));
                case 'Max'
                   level=max(masked_marker(:));
                case  'Min'
                   level=min(masked_marker(:));
                    
            end
            
            level=min(max(obj.slope.value*level+obj.intercept.value,0),1);
            current_marker(current_shape_mask)=level;
            result=current_marker;
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list={obj.marker.value};
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list={obj.region.value};
        end
       
    end
end