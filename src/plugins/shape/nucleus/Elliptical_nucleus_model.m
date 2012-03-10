classdef Elliptical_nucleus_model <SimuCell_Object_Model
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
        eccentricity;
        randomness;
        description='An Elliptical Model of Nucleus';
        
    end
    
    
    
    methods
        function obj=Elliptical_nucleus_model()
            obj.radius=Parameter('Cell Radius',30,SimuCell_Class_Type.number,...
                [1,Inf],'Average Cell Radius');
            obj.eccentricity=Parameter('Cell Eccentricity',0.5,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 0=spherical, 1=straight line');
            obj.randomness=Parameter('Extent of Variation',0.1,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 0=elliptical,1= random');
         
         
        end
        
        
        function output_shape=make_shape(obj,pos,current_image_mask,prerendered_shapes)
           x=pos(1);y=pos(2);
           intermediate_shape=elliptical_shape(obj.radius.value,obj.eccentricity.value,obj.randomness.value);
           output_shape=false(size(current_image_mask));
           shape_size=size(intermediate_shape);
           output_shape(x-floor(shape_size(1)/2-0.5):x-floor(shape_size(1)/2-0.5)+shape_size(1)-1,...
               y-floor(shape_size(2)/2-0.5):y-floor(shape_size(2)/2-0.5)+shape_size(2)-1)=logical(intermediate_shape);
        end
        
       
        function pre_obj_list=prerendered_object_list(obj)
             pre_obj_list=cell(0);
        end    
    end
    
  
    
end
