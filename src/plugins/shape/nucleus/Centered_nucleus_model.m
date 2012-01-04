classdef Centered_nucleus_model <SimuCell_Object
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
        eccentricity;
        centered_around;
        description='An Elliptical Model of Cell Shape';
        
    end
    
    
    
    methods
        function obj=Centered_nucleus_model()
            obj.radius=Parameter('Cell Radius',30,SimuCell_Class_Type.number,...
                [0,100],'Average Cell Radius');
            obj.eccentricity=Parameter('Cell Eccentricity',1,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 1=spherical, 0=straight line');
            obj.centered_around=Parameter('Placed at Center Of',[],SimuCell_Class_Type.simucell_shape_model,...
                [],'The nucleus is drawn at the center of this object (usually a cytoplasm)');
         
        end
        
        
        function output_shape=make_shape(obj,pos,current_image_mask,prerendered_shapes)
           cytoplasm=prerendered_shapes{1};
           dist_mask=bwdist(~cytoplasm);
           [rad,I]=max(dist_mask(:));
           rad=0.9*rad;
           [x,y]=ind2sub(size(current_image_mask),I);
           intermediate_shape=shape(obj.eccentricity.value,obj.eccentricity.value,min(obj.radius.value,rad));
           output_shape=false(size(current_image_mask));
           shape_size=size(intermediate_shape);
           output_shape(x-floor(shape_size(1)/2-0.5):x-floor(shape_size(1)/2-0.5)+shape_size(1)-1,...
               y-floor(shape_size(2)/2-0.5):y-floor(shape_size(2)/2-0.5)+shape_size(2)-1)=logical(intermediate_shape);
        end
        
       
        function pre_obj_list=prerendered_object_list(obj)
             pre_obj_list={obj.centered_around.value};
        end    
    end
    
  
    
end
