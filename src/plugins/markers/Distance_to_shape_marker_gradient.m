classdef Distance_to_shape_marker_gradient <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        distance_to
        falloff_type
        falloff_radius
        increasing_or_decreasing
        description='Scale marker level wrt distance  other shape';
    end
    
    methods
        function obj=Distance_to_shape_marker_gradient()
             obj.distance_to=Parameter('Distance To',0,SimuCell_Class_Type.simucell_shape_model,...
                [],'Marker levels are scaled based on distance to this shape');
             obj.falloff_radius=Parameter('Fall Off Radius',10,SimuCell_Class_Type.number,...
                [0,Inf],'Distance over which intensity falls off characteristically (e.g. 1/e)');
             obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',SimuCell_Class_Type.list,...
                {'Linear','Gaussian','Exponential'},'Functional form to calculate level fall-off');
             obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing','Increasing',SimuCell_Class_Type.list,...
                {'Increasing','Decreasing'},'Increasing or Decreasing function of distance to edge');
           
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
             
            distance_to_mask=needed_shapes{1};
            selected_region_mask=(current_shape_mask|distance_to_mask);
             se=strel('disk',2,8);
            [row,col]=find(imdilate(full(selected_region_mask),se));
            
            %[row,col]=find(selected_region_mask);
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