classdef SLML_nucleus_model <SimuCell_Object_Model
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        radius;
        filename;
        description='A nuclear shape model built using a model described via an SLML file';
       
    end
    
    
    properties (Access=private)
        model
    end
  
    
    methods
        function obj=SLML_nucleus_model()
            obj.radius=Parameter('Nucleus Radius',30,SimuCell_Class_Type.number,...
                [0,Inf],'Average Nuclear Radius');
            
            obj.filename=Parameter('SLML Filename',[],SimuCell_Class_Type.file_name,...
                @isMatFile,'SLML Filename');
         
            addlistener(obj.filename,'Parameter_Set',@obj.update_model);
        end
        
        
        function output_shape=make_shape(obj,pos,current_image_mask,prerendered_shapes)
            
           
            param.verbose = false;
            param.synthesize=[1 0 0];
            param.images = {};
            param = ml_initparam(param, ...
                struct('imageSize',[1024 1024],'gentex',0,'loc','all'));
            
            % nucimg=model2nuclei(model,param);
            
            [nucEdge,~] = ml_gencellcomp(obj.model, param );
            nucImage=imfill(nucEdge);
            
            
            
            [row,col]=find(nucImage>0);
            radius_created=round(sqrt((max(row)-min(row))^2+(max(col)-min(col))^2)/2);
            nucImage=nucImage(min(row):max(row),min(col):max(col));
            nucImage1=imresize(nucImage>0,obj.radius.value/radius_created);
            
            output_shape=false(size(current_image_mask));
            nucleus_size=size(nucImage1);
            output_shape(pos(1)-floor(nucleus_size(1)/2-0.5):pos(1)-floor(nucleus_size(1)/2-0.5)+nucleus_size(1)-1,...
                pos(2)-floor(nucleus_size(2)/2-0.5):pos(2)-floor(nucleus_size(2)/2-0.5)+nucleus_size(2)-1)=logical(nucImage1);
            
            
        end
        
        
        function pre_obj_list=prerendered_object_list(obj)
            pre_obj_list=cell(0);
        end
        
        
        function obj=update_model(obj,passed_variable,passed_event)
            temp=load(obj.filename.value);
            obj.model=temp.model;
            disp('slml nucleus model loaded successfully');
        end
        
    end
    
    
    
end
