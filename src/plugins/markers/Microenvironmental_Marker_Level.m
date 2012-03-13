classdef Microenvironmental_Marker_Level <SimuCell_Marker_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
       
        length_scale
        frequency_falloff
        noise_type
        description='Constant marker level determined by position of cell';
    end
    
    properties (Access=private)
        mevt
    end
    
    methods
        function obj=Microenvironmental_Marker_Level()
     
           
            obj.length_scale=Parameter('Length Scale',2,SimuCell_Class_Type.number,...
                [2,6],'Scale of Noise [2 - long length scale, 5-short]]');
            obj.frequency_falloff=Parameter('Frequency Falloff',0.5,SimuCell_Class_Type.number,...
                [0,1],'Frequency Falloff [0 (Only lowest frequency) - 1 (All frequencies)]]');
            obj.noise_type=Parameter('Noise Type','Standard 1/f',SimuCell_Class_Type.list,...
                {'Standard 1/f','Turbulent'},'Noise Type');
            addlistener(obj.length_scale,'Parameter_Set',@obj.generate_microenvironment);
            addlistener(obj.frequency_falloff,'Parameter_Set',@obj.generate_microenvironment);
            addlistener(obj.noise_type,'Parameter_Set',@obj.generate_microenvironment);
        end
        
        
        
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            
            [mx,my]=size(obj.mevt);
            [xres,yres]=size(current_shape_mask);
            
            
            [rows,cols]=find(current_shape_mask);
          
            rows1=min(max(round(rows*mx/xres),1),mx);
            cols1=min(max(round(cols*my/yres),1),my);
            
            I=sub2ind([mx,my],rows1,cols1);
            
            val=mean(obj.mevt(I));
            
            result=zeros(size(current_marker));
            result(current_shape_mask)=val;
            
            
        end
        
        function obj=generate_microenvironment(obj,passed_variable,passed_event)
           
            xres=1000;
            yres=1000;
            noise=zeros(xres,yres);
            
            for scale = obj.length_scale.value:5
                
                f = power(2,scale);
                
                weight = power(obj.frequency_falloff.value,scale);
                
                random_lattice = rand(f);
                random_lattice = [random_lattice(:,1) random_lattice random_lattice(:,end)];
                random_lattice = [random_lattice(1,:); random_lattice; random_lattice(end,:)];
                
                h = ones(3)/9;
                smoothed_random_lattice = conv2(random_lattice,h,'valid');
                
                y = linspace(1,size(smoothed_random_lattice,1),xres);
                x = linspace(1,size(smoothed_random_lattice,2),yres)';
                
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
            
            obj.mevt=(noise-min(noise(:)))/(max(noise(:))-min(noise(:)));
            
            disp('Microenvironment Calculated');
            
        end
        
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
        
    end
    
end
