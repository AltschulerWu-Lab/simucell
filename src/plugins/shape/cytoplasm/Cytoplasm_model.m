classdef Cytoplasm_model <SimuCell_Object_Model
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
        eccentricity
        description='An Elliptical Model of Cell Shape';
        
    end
    
    methods
        function obj=Cytoplasm_model()
            obj.radius=Parameter('Cell Radius',30,SimuCell_Class_Type.number,...
                [0,100],'Average Cell Radius');
            obj.eccentricity=Parameter('Cell Eccentricity',1,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 1=spherical, 0=straight line');
           
            
        end
        
        
        
        function output_shape=make_shape(obj,pos,current_image_mask,prerendred_shapes)
           intermediate_shape=shape(obj.eccentricity.value,obj.eccentricity.value,obj.radius.value);
           output_shape=false(size(current_image_mask));
           shape_size=size(intermediate_shape);
           %x=randi(obj.image_size(1)-shape_size(1));
           %y=randi(obj.image_size(2)-shape_size(2));
           x=pos(1);
           y=pos(2);
           output_shape(x-floor(shape_size(1)/2-0.5):x-floor(shape_size(1)/2-0.5)+shape_size(1)-1,...
               y-floor(shape_size(2)/2-0.5):y-floor(shape_size(2)/2-0.5)+shape_size(2)-1)=logical(intermediate_shape);
        end
        
        function pre_obj_list=prerendered_object_list(obj)
            pre_obj_list=cell(0);
        end
        
    end
    
end

