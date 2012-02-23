classdef Elliptical_cytoplasm_model <SimuCell_Object_Model
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
        eccentricity;
        centered_around;
        randomness;
        description='An Elliptical Cytoplasm centered around a nucleus';
        
    end
    
    
    
    methods
        function obj=Elliptical_cytoplasm_model()
            obj.radius=Parameter('Cell Radius',50,SimuCell_Class_Type.number,...
                [0,100],'Average Cell Radius');
            obj.eccentricity=Parameter('Cell Eccentricity',1,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 0=spherical, 1=straight line');
            obj.randomness=Parameter('Extent of Variation',0.05,SimuCell_Class_Type.number,...
                [0,1],'Measure of Non-Uniformity: 0=elliptical,1= random');
            obj.centered_around=Parameter('Placed at Center Of',[],SimuCell_Class_Type.simucell_shape_model,...
                [],'The cytoplasm is centered around this (usually a nucleus)');
            
        end
        
        
        function output_shape=make_shape(obj,pos,current_image_mask,prerendered_shapes)
            nucleus=prerendered_shapes{1};
            dists=bwdist(~nucleus);
            [nucRad,I]=max(dists(:));
            [nuc_center_x,nuc_center_y]=ind2sub(size(nucleus),I);
            
            
            
            step = 0.1;
            t = (0:step:1)'*2*pi;
            
           
            t1 = (obj.randomness.value*rand(size(t))+sin(t));
            t2 = sqrt(1-obj.eccentricity.value^2)*(obj.randomness.value*rand(size(t))+cos(t));
            t1(end) = t1(1);
            t2(end) = t2(1);
            
            theta=2*pi*rand();
            rotmat=[cos(theta) -sin(theta);sin(theta) cos(theta)];
            object = [t2';t1'];
            object=rotmat*object;
            
            dists=sum(object.^2,1);
            inds=find(dists<double(nucRad)/obj.radius.value);
            for i=1:length(inds)
                object(:,inds(i))=object(:,inds(i))*double(nucRad)/(obj.radius.value*dists(inds(i)));
            end
            
            points=max(obj.radius.value,double(nucRad))*object'+repmat([nuc_center_x,nuc_center_y],size(object,2),1);
            
       
            object=points';
            pp_nuc = cscvn(object);
            object = ppval(pp_nuc, linspace(0,max(pp_nuc.breaks),1000));
            
            
            
            object = round(object);
            
            output_shape = roipoly(false(size(nucleus)),object(2,:),object(1,:));
            output_shape=output_shape|nucleus;
            
        end
        
        
        function pre_obj_list=prerendered_object_list(obj)
            pre_obj_list={obj.centered_around.value};
        end
    end
    
    
    
end
