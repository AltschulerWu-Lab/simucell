classdef Perlin_Texture <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        amplitude
        length_scale
        frequency_falloff
        noise_type
        description='Perlin Texture. Scales the intensity by a randomly generated texture function';
    end
    
    methods
        function obj=Perlin_Texture()
            obj.amplitude=Parameter('Noise Amplitude',0.5,SimuCell_Class_Type.number,...
                [0,Inf],'Amplitude of Noise [0-low, 1-High]');
            obj.length_scale=Parameter('Length Scale',2,SimuCell_Class_Type.number,...
                [2,6],'Scale of Noise [2 - long length scale, 5-short]]');
            obj.frequency_falloff=Parameter('Frequency Falloff',0.5,SimuCell_Class_Type.number,...
                [0,1],'Scale of Noise [2 - long length scale, 5-short]]');
             obj.noise_type=Parameter('Noise Type','Standard 1/f',SimuCell_Class_Type.list,...
                {'Standard 1/f','Turbulent'},'Noise Type');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            
            tex=zeros(size(current_marker));
            [row,col]=find(current_shape_mask);
            
            noise=zeros(max(row)-min(row)+1,max(col)-min(col)+1);
            
            for scale = obj.length_scale.value:6
                
                f = power(2,scale);
                
                weight = power(obj.frequency_falloff.value,scale);
                
                random_lattice = rand(f);
                random_lattice = [random_lattice(:,1) random_lattice random_lattice(:,end)];
                random_lattice = [random_lattice(1,:); random_lattice; random_lattice(end,:)];
                
                h = ones(3)/9;
                smoothed_random_lattice = conv2(random_lattice,h,'valid');
                
                y = linspace(1,size(smoothed_random_lattice,1),max(row)-min(row)+1);
                x = linspace(1,size(smoothed_random_lattice,2),max(col)-min(col)+1)';
                
                if f < 3
                    method = 'bilinear';
                else
                    method = 'bicubic';
                end
                
                    
               
                temp_noise=interp2(smoothed_random_lattice,x,y,method);
                temp_noise=(temp_noise-min(temp_noise(:)))/(max(temp_noise(:))-min(temp_noise(:)));
                switch(obj.noise_type.value)
                    case 'Standard 1/f'
                         noise = noise + weight*temp_noise;
                    case 'Turbulent'
                        noise = noise + weight*abs(temp_noise);
                end
               
            end
            noise=(noise-min(noise(:)))/(max(noise(:))-min(noise(:)));
            noise= obj.amplitude.value*noise/std(noise(:));
            
            tex(min(row):max(row),min(col):max(col))=noise;
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
