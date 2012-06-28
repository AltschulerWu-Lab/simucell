classdef Distance_To_Edge_Marker_Gradient <SimuCell_Marker_Operation
  %Distance_To_Edge_Marker_Gradient marker plugin used to scale marker levels
  %based on distance to edge of shape
  %
  %Distance_To_Edge_Marker_Gradient Properties:
  %   falloff_radius - Characteristic distance from edge (in pixels) for
  %   intensity change
  %     Default value : 10
  %     Range value   : 0 to Inf
  %   falloff_type - Functional form to calculate level fall-off
  %     Default value : 'Gaussian'
  %     Available values : 'Linear','Gaussian','Exponential'
  %   increasing_or_decreasing - Increasing or Decreasing function of
  %   distance to edge
  %     Default value : 'Increasing'
  %     Available values : 'Increasing','Decreasing'
  %
  %Usage:
  %%Add Radial Gradient
  %%Have the intensity fall off rapidly with the distance to the edge
  %op=Distance_To_Edge_Marker_Gradient();
  %
  %%pixels over which intensity falls off by 1/e
  %set(op,'falloff_radius',10);
  %
  %%the intensity fall off functional form
  %set(op,'falloff_type','Gaussian');
  %
  %%Intensity decreases with distance to the edge
  %set(op,'increasing_or_decreasing','Decreasing');
  %
  %subpop{1}.markers.Myosin.cytoplasm.AddOperation(op);
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
    falloff_radius
    falloff_type
    increasing_or_decreasing
    description='Scale marker levels based on distance to edge of shape';
  end
  
  
  methods
    function obj=Distance_To_Edge_Marker_Gradient()
      obj.falloff_radius=Parameter('Fall Off Radius',10,...
        SimuCell_Class_Type.number,[0,Inf],...
        'Characteristic distance from edge (in pixels) for intensity change');
      obj.falloff_type=Parameter('Intensity FallOff Type','Gaussian',...
        SimuCell_Class_Type.list,{'Linear','Gaussian','Exponential'},...
        'Functional form to calculate level fall-off');
      obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing',...
        'Increasing',SimuCell_Class_Type.list,{'Increasing','Decreasing'},...
        'Increasing or Decreasing function of distance to edge');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,...
        other_cells_mask,needed_shapes,needed_markers)
      se=strel('disk',2,8);
      [row,col]=find(imdilate(full(current_shape_mask),se));
      selected_region=current_marker(min(row):max(row),min(col):max(col));
      selected_mask=current_shape_mask(min(row):max(row),min(col):max(col));
      z=bwdist(~full(selected_mask));
      switch obj.falloff_type.value
        case 'Linear'
          z=max(min(1-z/obj.falloff_radius.value,1),0);
        case 'Gaussian'
          z=exp(-(z/obj.falloff_radius.value).^2);
          %z=exp(-obj.falloff_coefficient.value*z.^2/((radius)^2));
        case 'Exponential'
          z=exp(-(z/obj.falloff_radius.value));
          %z=exp(-obj.falloff_coefficient.value*z/radius);
      end
      if(strcmp(obj.increasing_or_decreasing.value,'Increasing'))
        z=1-z;
      end
      selected_region=max(min(full(selected_region).*z,1),0);
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
