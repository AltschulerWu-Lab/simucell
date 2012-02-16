classdef Cell_Density_Dependant_Marker_Level <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        falloff_type
        falloff_coefficient
        increasing_or_decreasing
        description='Scale marker level wrt distance  other shape';
    end
    
    methods
        function obj=Cell_Density_Dependant_Marker_Level()
             
             obj.falloff_coefficient=Parameter('Fall Off Radius',0.1,SimuCell_Class_Type.number,...
                [0,Inf],'Parameter controlling how fast the marker level drops (0- flat, 1- characteristic falloff, Inf- Instantaneous falloff)');
             obj.falloff_type=Parameter('Functional Form Of Dependance','Gaussian',SimuCell_Class_Type.list,...
                {'Linear','Gaussian','Exponential'},'Functional form to calculate marker level based on distance to other cells');
             obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing','Gaussian',SimuCell_Class_Type.list,...
                {'Increasing','Decreasing'},'Increasing or Decreasing function of distance to edge');
           
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
           
            [xres,yres]=size(current_shape_mask);
            z=bwdist(full(other_cells_mask));
            radius=sqrt(xres^2+yres^2);   
            if(strcmp(obj.increasing_or_decreasing.value,'Increasing'))
                z=radius-z;
            end
                
            mean_val=mean(z(current_shape_mask));          
            switch obj.falloff_type.value
                 case 'Linear'
                  val=max(1-obj.falloff_coefficient.value*mean_val/radius,0);  
              case 'Gaussian'    
                  
                 val=exp(-obj.falloff_coefficient.value*mean_val.^2/((radius)^2));
              case 'Exponential'
                  val=exp(-obj.falloff_coefficient.value*mean_val/radius);
              
            end
            
           
            val=max(min(val,1),0);
            
            result=current_marker;
            result(current_shape_mask)=val;
            
            
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end