classdef Linear_Marker_Gradient <SimuCell_Marker_Operation
  %Linear_Marker_Gradient marker plugin used to scale intensities by a linear
  %gradient on image in random direction. The falloff in this direction can
  %be linear,exponential or sigmoidal. The max and min value of the intensity
  %scaling can be specified
  %
  %Linear_Marker_Gradient Properties:
  %   falloff_coefficient - Measures how quickly intensity falls off
  %   [0 -slow, 1- immediately]
  %     Default value : 0.1
  %     Range value : 0 to 1
  %   max_multiplier - Max value multiplying the input intensities
  %     Default value : 1
  %     Range value : 0 to Inf
  %   min_multiplier - Min value multiplying the input intensities
  %     Default value : 0
  %     Default value : 0 to Inf
  %   falloff_type - Functional form to calculate intensity fall-off
  %     Default value : 'Linear'
  %     Available values : 'Linear','Exponential','Sigmoidal'
  %
  %Usage:
  %%Add Linear Gradient
  %op=Linear_Marker_Gradient();
  %
  %%Set how quickly intensity falls off (0 slow, 1 immediately)
  %set(op,'falloff_coefficient',0.1);
  %
  %%Max value multiplying the input intensities
  %set(op,'max_multiplier','1');
  %
  %%Distance is measure wrt the nucleus
  %set(op,falloff_type,'Linear');
  %
  %%Add the operation to the object marker
  %subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
  %
  %
  % ------------------------------------------------------------------------------
  % Copyright ©2012, The University of Texas Southwestern Medical Center 
  % Authors:
  % Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
  % For latest updates, check: < http://www.SimuCell.org >.
  %
  % All rights reserved.
  % This program is free software: you can redistribute it and/or modify
  % it under the terms of the GNU General Public License as published by
  % the Free Software Foundation, version 3 of the License.
  %
  % This program is distributed in the hope that it will be useful,
  % but WITHOUT ANY WARRANTY; without even the implied warranty of
  % MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  % GNU General Public License for more details:
  % < http://www.gnu.org/licenses/ >.
  %
  % ------------------------------------------------------------------------------
  %%
  
    
  
  properties
    falloff_coefficient
    max_multiplier
    min_multiplier
    falloff_type
    description=['Scale intensities by a linear gradient on image in '...
      'random direction. The falloff in this direction can be linear, '...
      'exponential or sigmoidal. The max and min value of the '...
      'intensity scaling can be specified'];
  end
  
  
  methods
    function obj=Linear_Marker_Gradient()
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
    
    function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
      [row,col]=find(current_shape_mask);
      selected_region=current_marker(min(row):max(row),min(col):max(col));
      selected_mask=current_shape_mask(min(row):max(row),min(col):max(col));
      [xres,yres]=size(selected_region);
      [X,Y]=meshgrid(1:yres,1:xres);
      theta=2*pi*rand();
      z=cos(theta)*X+sin(theta)*Y;
      switch obj.falloff_type.value
        case 'Linear'
        case 'Exponential'
          max_r=sqrt(xres^2+yres^2);%Is this really ideal? What if cells have different sizes?
          z=exp(-(obj.falloff_coefficient.value+1E-10)*z/(max_r));
        case 'Sigmoidal'
          z=(z-min(z(:)))/(max(z(:))-min(z(:)))-0.5;
          z=tanh(5*(obj.falloff_coefficient.value+1E-10)*z);
      end
      z=(z-min(z(:)))/(max(z(:))-min(z(:)));
      z=z*(obj.max_multiplier.value-obj.min_multiplier.value)+obj.min_multiplier.value;
      selected_region=max(min(selected_region.*z,1),0);
      result=current_marker;
      result(current_shape_mask)=selected_region(selected_mask);
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list=cell(0);
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list=cell(0);
    end
    
  end
  
  
end
