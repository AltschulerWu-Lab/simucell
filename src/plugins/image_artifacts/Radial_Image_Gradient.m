classdef Radial_Image_Gradient <SimuCell_CellArtifact_Operation
  %Radial_Image_Gradient image artifact plugin used to sccale intensities
  %by a radial gradient on image in random location. The falloff in this
  %direction can be linear,exponential or sigmoidal. The max and min value
  %of the intensity scaling can be specified.
  %
  %Radial_Image_Gradient Properties:
  %   falloff_radius - Distance (in pixels) over which radius falls off
  %     Default value : 100
  %     Range value   : 1 to Inf
  %   max_multiplier     - Max value multiplying the input intensities
  %     Default value : 1
  %     Range value   : 0 to Inf
  %   min_multiplier     - Min value multiplying the input intensities
  %     Default value : 0
  %     Range value   : 0 to Inf
  %   falloff_type       - Functional form to calculate intensity fall-off
  %     Default value : 'Linear'
  %     Available Values: 'Linear','Gaussian','Exponential','Sigmoidal'
  %
  %Usage:
  %op=Radial_Image_Gradient();
  %set(op,'falloff_radius',100);
  %set(op,'max_multiplier',1);
  %set(op,'min_multiplier',0);
  %set(op,'falloff_type','Linear');
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    falloff_type
    falloff_radius
    max_multiplier
    min_multiplier
    description=['Scale intensities by a radial gradient on image in'...
      ' random location. The falloff in this direction can be linear,'...
      'exponential or sigmoidal. The max and min value of the intensity'...
      ' scaling can be specified'];
  end
  
  
  methods
    
    function obj=Radial_Image_Gradient()
      obj.falloff_radius=Parameter('Fall Off Radius',100,...
        SimuCell_Class_Type.number,...
        [1,Inf],'Distance (in pixels) over which radius falls off');
      obj.max_multiplier=Parameter('Max Intensity Scaling',1,...
        SimuCell_Class_Type.number,...
        [0,Inf],'Max value multiplying the input intensities');
      obj.min_multiplier=Parameter('Min Intensity Scaling',0,...
        SimuCell_Class_Type.number,...
        [0,Inf],'Min value multiplying the input intensities');
      obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',...
        SimuCell_Class_Type.list,...
        {'Linear','Gaussian','Exponential','Sigmoidal'},...
        'Functional form to calculate intensity fall-off');
    end
    
    function output_images=Apply(obj,input_images)
      [xres,yres]=size(input_images{1});
      x=randi(xres,1);
      y=randi(yres,1);
      mask=false(xres,yres);
      mask(x,y)=true;
      z=bwdist(mask);
      switch obj.falloff_type.value
        case 'Linear'
          z=-z;
        case 'Gaussian'
          z=exp(-z.^2/((obj.falloff_radius.value+1)^2));
        case 'Exponential'
          z=exp(-z/((obj.falloff_radius.value+1)));
        case 'Sigmoidal'
          z=(z-min(z(:)))/(max(z(:))-min(z(:)))-0.5;
          %Improve this!
          z=tanh(-100*z/obj.falloff_radius.value);
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