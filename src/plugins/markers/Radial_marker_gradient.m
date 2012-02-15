classdef Radial_marker_gradient <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      falloff_type
        falloff_radius
        max_multiplier
        min_multiplier
        distance_measured_wrt
        inside_or_to
        increasing_or_decreasing
        description='Scale marker level using distance measured wrt specified object';
    end
    
    methods
        function obj=Radial_marker_gradient()
             obj.falloff_radius=Parameter('Fall Off Radius',0.1,SimuCell_Class_Type.number,...
                [1,Inf],'Distance (in pixels) over which radius falls off');
             obj.max_multiplier=Parameter('Max Intensity Scaling',1,SimuCell_Class_Type.number,...
                [0,Inf],'Max value multiplying the input intensities');
             obj.min_multiplier=Parameter('Min Intensity Scaling',0,SimuCell_Class_Type.number,...
                [0,Inf],'Min value multiplying the input intensities');
             obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',SimuCell_Class_Type.list,...
                {'Linear','Gaussian','Exponential','Sigmoidal'},'Functional form to calculate intensity fall-off');
             obj.distance_measured_wrt=Parameter('Distance From Edge Of',0,SimuCell_Class_Type.simucell_shape_model,...
                [],'Region from whose edge distances are calculated');
            obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing','Gaussian',SimuCell_Class_Type.list,...
                {'Increasing','Decreasing'},'Increasing or Decreasing function of distance');
            obj.inside_or_to=Parameter('Distance Measured:','Gaussian',SimuCell_Class_Type.list,...
                {'To Object','To Exterior'},'Distance to object or to the region outside object');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            distance_from_mask=needed_shapes{1};
            [row,col]=find(current_shape_mask||distance_from_mask);
            selected_region=current_marker(min(row):max(row),min(col):max(col));
            selected_mask=current_shape_mask(min(row):max(row),min(col):max(col));
            
            
            [xres,yres]=size(selected_region);
            [X,Y]=meshgrid(1:yres,1:xres);
            theta=2*pi*rand();
            z=cos(theta)*X+sin(theta)*Y;
            
            switch obj.falloff_type.value
                case 'Linear'
                    
                case 'Exponential'
                    max_r=sqrt(xres^2+yres^2);%Is this really ideal? What if cells have different sizes?
                    z=exp(-(obj.falloff_coefficient.value+1E-10)*z/(max_r));
                case 'Sigmoidal'
                    z=(z-min(z(:)))/(max(z(:))-min(z(:)))-0.5;
                    z=tanh(5*(obj.falloff_coefficient.value+1E-10)*z);
            end
            
            z=(z-min(z(:)))/(max(z(:))-min(z(:)));
            z=z*(obj.max_multiplier.value-obj.min_multiplier.value)+obj.min_multiplier.value;
            selected_region=max(min(selected_region.*z,1),0);
            
            result=current_marker;
            result(current_shape_mask)=selected_region(selected_mask);
            
            
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list={obj.distance_measured_wrt.value};
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end