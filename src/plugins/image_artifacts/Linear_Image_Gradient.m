classdef Linear_Image_Gradient <SimuCell_ImageArtifact_Operation
  %Linear_Image_Gradient image artifact plugin used to scale intensities
  %by a linear gradient on image in random direction. The falloff in this
  %direction can be linear,exponential or sigmoidal. The max and min value
  %of the intensity scaling can be specified.
  %
  %Linear_Image_Gradient Properties:
  %   falloff_coefficient - Measures how quickly intensity falls off
  %   [0 - slow, 1 - immediately].
  %     Default value : 0.1
  %     Range value   : 0 to 1
  %   max_multiplier     - Max value multiplying the input intensities
  %     Default value : 1
  %     Range value   : 0 to Inf
  %   min_multiplier     - Min value multiplying the input intensities
  %     Default value : 0
  %     Range value   : 0 to Inf
  %   falloff_type       - Functional form to calculate intensity fall-off
  %     Default value : 'Linear'
  %     Available Values: 'Linear','Exponential','Sigmoidal'
  %
  %Usage:
  %op=Linear_Image_Gradient();
  %set(op,'falloff_coefficient',0.1);
  %set(op,'max_multiplier',1);
  %set(op,'min_multiplier',0);
  %set(op,'falloff_type','Linear');
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    falloff_type
    falloff_coefficient
    max_multiplier
    min_multiplier
    description=['Scale intensities by a linear gradient on image in'...
      ' random direction. The falloff in this direction can be linear,'...
      'exponential or sigmoidal. The max and min value of the intensity'...
      ' scaling can be specified'];
  end
  
  
  methods
    
    function obj=Linear_Image_Gradient()
      obj.falloff_coefficient=Parameter('Fall Off Coefficient',0.1,...
        SimuCell_Class_Type.number,[0,1],...
        'Measures how quickly intensity falls off [0 -slow, 1- immediately]');
      obj.max_multiplier=Parameter('Max Intensity Scaling',1,...
        SimuCell_Class_Type.number,...
        [0,Inf],'Max value multiplying the input intensities');
      obj.min_multiplier=Parameter('Min Intensity Scaling',0,...
        SimuCell_Class_Type.number,...
        [0,Inf],'Min value multiplying the input intensities');
      obj.falloff_type=Parameter('Intensity FallOff Type','Linear',...
        SimuCell_Class_Type.list,...
        {'Linear','Exponential','Sigmoidal'},...
        'Functional form to calculate intensity fall-off');
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