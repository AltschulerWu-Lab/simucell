classdef Perlin_Texture <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        amplitude
        scale
        description='Constant Marker Level. This level is sampled from a Normal Distribution with Specified Mean and Standard Deviation';
    end
    
    methods
        function obj=Perlin_Texture()
            obj.amplitude=Parameter('Scale',0.5,SimuCell_Class_Type.number,...
                [0,1],'Amplitude of Noise [0-low, 1-High]');
            obj.scale=Parameter('Amplitude',1,SimuCell_Class_Type.number,...
                [1,5],'Scale of Noise [1 - long length scale, 5-short]]');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            
            tex=zeros(size(current_marker));
            [row,col]=find(current_shape_mask);
            tex(min(row):max(row),min(col):max(col))=texture(...
                [max(row)-min(row)+1,max(col)-min(col)+1],obj.amplitude.value,2,...
                2+round(obj.scale.value),0.1);
           
%             tex(object_mask)=tex(object_mask)./...
%             mean(mean(tex(object_mask)));
             result=min(current_marker.*sparse(tex),1);

            
            
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end