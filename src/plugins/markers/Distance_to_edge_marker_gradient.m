classdef Distance_to_edge_marker_gradient <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       
        falloff_type
        falloff_radius
        increasing_or_decreasing
        description='Scale marker level wrt distance to edge of shape (this should give shape contours)';
    end
    
    methods
        function obj=Distance_to_edge_marker_gradient()
             obj.falloff_radius=Parameter('Fall Off Radius',10,SimuCell_Class_Type.number,...
                [0,Inf],'Characteristic distance from edge (in pixels) for intensity change');
             obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',SimuCell_Class_Type.list,...
                {'Linear','Gaussian','Exponential'},'Functional form to calculate level fall-off');
             obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing','Increasing',SimuCell_Class_Type.list,...
                {'Increasing','Decreasing'},'Increasing or Decreasing function of distance to edge');
           
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            se=strel('disk',2,8);
            [row,col]=find(imdilate(full(current_shape_mask),se));
            
            selected_region=current_marker(min(row):max(row),min(col):max(col));
            selected_mask=current_shape_mask(min(row):max(row),min(col):max(col));
            
           
            z=bwdist(~full(selected_mask));
           
                
                      
            switch obj.falloff_type.value
                 case 'Linear'
                  z=max(min(1-z/obj.falloff_radius.value,1),0);  
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
            result(current_shape_mask)=selected_region(selected_mask);
            
            
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end