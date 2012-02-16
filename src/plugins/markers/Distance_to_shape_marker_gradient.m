classdef Distance_to_shape_marker_gradient <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        distance_to
        falloff_type
        falloff_coefficient
        increasing_or_decreasing
        description='Scale marker level wrt distance  other shape';
    end
    
    methods
        function obj=Distance_to_shape_marker_gradient()
             obj.distance_to=Parameter('Distance To',0,SimuCell_Class_Type.simucell_shape_model,...
                [],'Marker levels are scaled based on distance to this shape');
             obj.falloff_coefficient=Parameter('Fall Off Radius',0.1,SimuCell_Class_Type.number,...
                [0,Inf],'Parameter controlling how fast the marker level drops (0- flat, 1- characteristic falloff, Inf- Instantaneous falloff)');
             obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',SimuCell_Class_Type.list,...
                {'Linear','Gaussian','Exponential'},'Functional form to calculate level fall-off');
             obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing','Gaussian',SimuCell_Class_Type.list,...
                {'Increasing','Decreasing'},'Increasing or Decreasing function of distance to edge');
           
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
             
            distance_to_mask=needed_shapes{1};
            selected_region_mask=(current_shape_mask|distance_to_mask);
            
            [row,col]=find(selected_region_mask);
            selected_region=current_marker(min(row):max(row),min(col):max(col));
            selected_current_shape_mask=current_shape_mask(min(row):max(row),min(col):max(col));
            selected_distance_to_mask=distance_to_mask(min(row):max(row),min(col):max(col));
            
            
            z=bwdist(full(selected_distance_to_mask));
            radius=max(abs(z(selected_current_shape_mask)));   
            if(strcmp(obj.increasing_or_decreasing.value,'Increasing'))
                z=radius-z;
            end
                
                      
            switch obj.falloff_type.value
                 case 'Linear'
                  z=max(1-obj.falloff_coefficient.value*z/radius,0);  
              case 'Gaussian'    
                  
                  z=exp(-obj.falloff_coefficient.value*z.^2/((radius)^2));
              case 'Exponential'
                  z=exp(-obj.falloff_coefficient.value*z/radius);
              
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