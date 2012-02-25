classdef Linear_Image_Gradient <SimuCell_CellArtifact_Operation
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        falloff_type
        falloff_coefficient
        max_multiplier
        min_multiplier
        description='Scale intensities by a linear gradient on image in random direction. The falloff in this direction can be linear,exponential or sigmoidal. The max and min value of the intensity scaling can be specified';
    end
    
    methods
        function obj=Linear_Image_Gradient()
            obj.falloff_coefficient=Parameter('Fall Off Coefficient',0.1,SimuCell_Class_Type.number,...
                [0,1],'Measures how quickly intensity falls off [0 -slow, 1- immediately]');
             obj.max_multiplier=Parameter('Max Intensity Scaling',1,SimuCell_Class_Type.number,...
                [0,Inf],'Max value multiplying the input intensities');
             obj.min_multiplier=Parameter('Min Intensity Scaling',0,SimuCell_Class_Type.number,...
                [0,Inf],'Min value multiplying the input intensities');
             obj.falloff_type=Parameter('Intensity FallOff Type','Linear',SimuCell_Class_Type.list,...
                {'Linear','Exponential','Sigmoidal'},'Functional form to calculate intensity fall-off');
        end
        
        
        
        function output_images=Apply(obj,input_images)
          [xres,yres]=size(input_images{1}) ;
          [X,Y]=meshgrid(1:yres,1:xres);
          theta=2*pi*rand();
          z=cos(theta)*X+sin(theta)*Y;
          switch obj.falloff_type.value
              case 'Linear'
                
              case 'Exponential'
                  max_r=sqrt(xres^2+yres^2);
                  z=exp(-(obj.falloff_coefficient.value+1E-10)*z/(max_r));
              case 'Sigmoidal'
                  z=(z-min(z(:)))/(max(z(:))-min(z(:)))-0.5;
                  z=tanh(5*(obj.falloff_coefficient.value+1E-10)*z);
          end
          
          z=(z-min(z(:)))/(max(z(:))-min(z(:)));
          z=z*(obj.max_multiplier.value-obj.min_multiplier.value)+obj.min_multiplier.value;
          
          number_of_channels=size(input_images,1);
          output_images=cell(number_of_channels,1);
          for channel=1:number_of_channels
            output_images{channel}=max(min(input_images{channel}.*z,1),0);
          end    
        end
        
        
    end
end