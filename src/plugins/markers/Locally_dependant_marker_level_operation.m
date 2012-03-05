classdef Locally_dependant_marker_level_operation <SimuCell_Marker_Operation
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
        function obj=Locally_dependant_marker_level_operation()
            obj.slope=Parameter('Slope',1,SimuCell_Class_Type.number,...
                [-Inf,Inf],'Slope of linear transform');
            obj.intercept=Parameter('Intercept',0,SimuCell_Class_Type.number,...
                [-Inf,Inf],'Intercept of linear transform');
           obj.marker=Parameter('Marker',0,SimuCell_Class_Type.simucell_marker_model,...
                [],'Chosen Marker (on shape)');
           
          
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
           
            other_marker=needed_markers{1};
            %masked_marker=other_marker(current_shape_mask);
            current_marker=zeros(size(current_shape_mask));        
            
            temp=min(max(obj.slope.value*other_marker+obj.intercept.value,0),1);
            current_marker(current_shape_mask)=temp(current_shape_mask);
            result=current_marker;
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list={obj.marker.value};
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end