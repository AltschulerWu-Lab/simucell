classdef Cell_Density_Dependant_Marker_Level <SimuCell_Marker_Operation
  %Cell_Density_Dependant_Marker_Level marker plugin used to scale marker
  %levels based on local cell density.
  %
  %Cell_Density_Dependant_Marker_Level Properties:
  %   increasing_or_decreasing - Increasing or Decreasing function of local
  %   cell density
  %     Default value : Increasing
  %     Available values   : 'Increasing','Decreasing'
  %   falloff_radius - Distance (in pixels) over which intensity falls of
  %   characteristically
  %     Default value : 200
  %     Range value   : 0 to Inf
  %   falloff_type - Functional form to calculate marker level based on
  %   distance to other cells
  %     Default value : 'Gaussian'
  %     Available Values: 'Linear','Exponential','Gaussian'
  %   min_level - Min Level (theoretically, without saturation etc) that
  %   Marker could reach
  %     Default value : 0
  %     Range value   : 0 to Inf
  %   max_level - Max Level (theoretically, without saturation etc) that
  %   Marker can reach
  %     Default value : 1
  %     Range value   : 0 to Inf
  %
  %Usage:
  % add_marker(subpop{2},'Density_Marker','Blue');
  %
  % op=Cell_Density_Dependant_Marker_Level();
  % set(op,'max_level',2);
  % set(op,'falloff_radius',200);
  % set(op,'falloff_type','Gaussian');
  % set(op,'increasing_or_decreasing','Decreasing');
  %
  % subpop{2}.markers.Density_Marker.nucleus.AddOperation(op);
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
    increasing_or_decreasing
    falloff_radius
    falloff_type
    min_level;
    max_level;
    description='Scale marker levels based on local cell density';
  end
  
  
  methods
    
    function obj=Cell_Density_Dependant_Marker_Level()
      obj.increasing_or_decreasing=Parameter('Increasing Or Decreasing',...
        'Increasing',SimuCell_Class_Type.list,...
        {'Increasing','Decreasing'},...
        'Increasing or Decreasing function of local cell density');
      obj.falloff_radius=Parameter('Fall Off Radius',200,...
        SimuCell_Class_Type.number, [0,Inf],...
        'Distance (in pixels) over which intensity falls of characteristically');
      obj.falloff_type=Parameter('Functional Form Of Dependance',...
        'Gaussian',SimuCell_Class_Type.list,...
        {'Linear','Gaussian','Exponential'},...
        'Functional form to calculate marker level based on distance to other cells');
      obj.min_level=Parameter('Amplitude',0,SimuCell_Class_Type.number,...
        [0,Inf],...
        'Min Level (theoretically, without saturation etc) that Marker could reach');
      obj.max_level=Parameter('Max Theoretical Intensity ',...
        1,SimuCell_Class_Type.number, [0,Inf],...
        'Max Level (theoretically, without saturation etc) that Marker can reach');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,...
        other_cells_mask,needed_shapes,needed_markers)
      z=bwdist(full(other_cells_mask));
      mean_val=mean(z(current_shape_mask));
      switch obj.falloff_type.value
        case 'Linear'
          val=max(1-mean_val/obj.falloff_radius.value,0);
        case 'Gaussian'
          val=exp(-(mean_val/obj.falloff_radius.value)^2);
        case 'Exponential'
          val=exp(-(mean_val/obj.falloff_radius.value));
      end
      if(~strcmp(obj.increasing_or_decreasing.value,'Increasing'))
        val=max(1-val,0);
      end
      val=max(min(val,1),0);
      val=(obj.max_level.value-obj.min_level.value)*val+obj.min_level.value;
      result=current_marker;
      result(current_shape_mask)=val;
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list=cell(0);
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list=cell(0);
    end
    
  end
  
  
end
