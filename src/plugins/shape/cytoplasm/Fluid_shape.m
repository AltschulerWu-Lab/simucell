classdef Fluid_shape <SimuCell_Object_Model
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
        eccentricity
        randomness
        description='An elliptical model of cell shape, which turns fluid to avoid overlap';
        
    end
    
    methods
        function obj=Fluid_shape()
            obj.radius=Parameter('Cell Radius',30,SimuCell_Class_Type.number,...
                [0,100],'Average Cell Radius');
            obj.eccentricity=Parameter('Cell Eccentricity',0.5,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 1=spherical, 0=straight line');
            obj.randomness=Parameter('Randomness',0.05,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 0=elliptical,1= random');
            
        end
        
        
        
        function output_shape=make_shape(obj,pos,current_image_mask,prerendred_shapes)
            [max_x,max_y]=size(current_image_mask);
           intermediate_shape=elliptical_shape(obj.radius.value,obj.eccentricity.value,obj.randomness.value);
           
           temp_shape=false(size(current_image_mask));
           shape_size=size(intermediate_shape);
           %x=randi(obj.image_size(1)-shape_size(1));
           %y=randi(obj.image_size(2)-shape_size(2));
           x=pos(1);
           y=pos(2);
           temp_shape(x-floor(shape_size(1)/2-0.5):x-floor(shape_size(1)/2-0.5)+shape_size(1)-1,...
               y-floor(shape_size(2)/2-0.5):y-floor(shape_size(2)/2-0.5)+shape_size(2)-1)=logical(intermediate_shape);
           target_area=nnz(temp_shape);
           se=strel('line',2,2*pi*rand());
           max_attempts=50;
           attempt_num=1;
           temp_area=nnz(temp_shape&(~current_image_mask));
           while(temp_area<target_area && attempt_num<max_attempts)
               allowed_shape=temp_shape&(~current_image_mask);
               [rows,cols]=find(allowed_shape);
               x1=max(min(rows)-2,1);
               x2=min(max(rows)+2,max_x);
               y1=max(min(cols)-2,1);
               y2=min(max(cols)+2,max_y);
               
               temp=allowed_shape(x1:x2,y1:y2);
               temp=imdilate(temp,se);
               temp_shape=false(max_x,max_y);
               temp_shape(x1:x2,y1:y2)=temp;
               
               temp_area=nnz(temp_shape &(~current_image_mask));
               
               attempt_num=attempt_num+1;
           end
           
           output_shape=temp_shape&(~current_image_mask);
           
        end
        
        function pre_obj_list=prerendered_object_list(obj)
            pre_obj_list=cell(0);
        end
        
    end
    
end

