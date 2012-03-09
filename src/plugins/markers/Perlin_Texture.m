classdef Perlin_Texture <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        add_or_multiply
        amplitude
        length_scale
        frequency_falloff
        noise_type
        description='Perlin Texture. Scales the intensity by a randomly generated texture function';
    end
    
    methods
        function obj=Perlin_Texture()
            obj.add_or_multiply=Parameter('Additive or Multiplicative','Multiply',SimuCell_Class_Type.list,...
                {'Add','Multiply'},'Should the noise be additive or multiplicative?');
            obj.amplitude=Parameter('Noise Amplitude',0.5,SimuCell_Class_Type.number,...
                [0,Inf],'Amplitude of Noise [0-low, 1-High]');
            obj.length_scale=Parameter('Length Scale',2,SimuCell_Class_Type.number,...
                [2,6],'Scale of Noise [2 - long length scale, 5-short]]');
            obj.frequency_falloff=Parameter('Frequency Falloff',0.5,SimuCell_Class_Type.number,...
                [0,1],'Frequency Falloff [0 (Only lowest frequency) - 1 (All frequencies)]]');
            obj.noise_type=Parameter('Noise Type','Standard 1/f',SimuCell_Class_Type.list,...
                {'Standard 1/f','Turbulent'},'Noise Type');
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            
            tex=zeros(size(current_marker));
            [row,col]=find(current_shape_mask);
            shape_mask=current_shape_mask(min(row):max(row),min(col):max(col));
            
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
            noise=(noise-min(noise(shape_mask)))/(max(noise(shape_mask))-min(noise(shape_mask)));
            noise=noise-mean(noise(shape_mask));
            noise= obj.amplitude.value*noise/std(noise(shape_mask));
            
            m=mean(current_marker(current_shape_mask));
            temp=current_marker(min(row):max(row),min(col):max(col));
            switch(obj.add_or_multiply.value)
                case 'Add'
                    temp=temp+noise;
                    temp=temp(shape_mask);
                    
                case 'Multiply'
                    
                    temp=temp.*(noise+1);
                    temp=temp(shape_mask);
                    
            end
            
            
            [p,z]=hist(temp(:),100);
            p=p/sum(p);
            
            [alpha,~,exitflag]=fzero(@(a) norm_fn(a,p,full(z),full(m)),sum(p.*full(z))-m);
            if(exitflag~=1)
                alpha=sum(p.*full(z))-m;
                %alpha= full(m)/sum(p.*full(z));
                if(isnan(m)||isinf(m))
                    alpha=1;
                end
                
            end
            
            tex(min(row):max(row),min(col):max(col))=noise;
            
            switch(obj.add_or_multiply.value)
                case 'Add'
                    result=max(min(current_marker+sparse(tex)-alpha,1),0);
                case 'Multiply'
                
                    result=max(min(current_marker.*sparse(tex+1)-alpha,1),0);
            end
            
            
            
            
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
        
    end
    
end
