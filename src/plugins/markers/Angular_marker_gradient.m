classdef Angular_marker_gradient <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        center
        angular_width
        falloff_type
        max_multiplier
        min_multiplier
        description='Scale intensities by an angular gradient on image in random direction.';
        
    end
    
    methods
        function obj=Angular_marker_gradient()
            obj.center=Parameter('Angle Measured From','Centroid',SimuCell_Class_Type.list,...
                {'Centroid','Furthest From Edge','Random'},'Point wrt which angles are measured');
            obj.angular_width=Parameter('Angular Width (degrees)',30,SimuCell_Class_Type.number,...
                [0,360],'Angular Width Of High Intesity Region');
            obj.falloff_type=Parameter('Intensity FallOff Type','Linear',SimuCell_Class_Type.list,...
                {'Linear','Exponential','Sigmoidal'},'Functional form to calculate intensity fall-off');
            obj.min_multiplier=Parameter('Min Intensity Scaling',0,SimuCell_Class_Type.number,...
                [0,Inf],'Min value multiplying the input intensities');
           
            obj.max_multiplier=Parameter('Min Intensity Scaling',1,SimuCell_Class_Type.number,...
                [0,Inf],'Min value multiplying the input intensities');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            [row,col]=find(current_shape_mask);
            selected_region=current_marker(min(row):max(row),min(col):max(col));
            selected_mask=current_shape_mask(min(row):max(row),min(col):max(col));
            
            [xres,yres]=size(selected_region);
            [X,Y]=meshgrid(1:yres,1:xres);
            
            switch obj.center.value
                case 'Centroid'
                    [row,col]=find(selected_mask);
                    x=mean(row);
                    y=mean(col);
                case 'Furthest From Edge'
                    dists=bwdist(~full(selected_mask));
                    [~,I]=max(dists(:));
                    [x,y]=ind2sub([xres,yres],I);
                case 'Random'
                    [row,col]=find(selected_mask);
                    i=randsample(length(row),1);
                    x=row(i);y=col(i);
            end
            
            theta=2*pi*rand();
            X1=cos(theta)*(X-x)-sin(theta)*(Y-y);
            Y1=sin(theta)*(X-x)+cos(theta)*(Y-y);
            z=180*abs(atan2(Y1,X1))/pi;
            
            
            
            switch obj.falloff_type.value
                case 'Linear'
                    
                case 'Exponential'
                   %Is this really ideal? What if cells have different sizes?
                    z=exp(-z/(obj.angular_width.value));
                case 'gaussian'
                   z=exp(-z.^2/(obj.angular_width.value)^2);
            end
            
            z=(z-min(z(:)))/(max(z(:))-min(z(:)));
            z=z*(obj.max_multiplier.value-obj.min_multiplier.value)+obj.min_multiplier.value;
            selected_region=max(min(selected_region.*z,1),0);
            
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