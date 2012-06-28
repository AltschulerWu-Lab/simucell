classdef Locally_Dependant_Marker_Level <SimuCell_Marker_Operation
  %Locally_Dependant_Marker_Level constant marker level dependant
  %(linearly) on level of chosen marker on a specified region.
  %Output level is slope*F(marker_shape|region)+intercept.
  %F is the function (mean,median etc) calculated on marker restricted
  %to region.
  %
  %Locally_Dependant_Marker_Level Properties:
  %   slope - Slope of linear transform
  %   [0 -slow, 1- immediately]
  %     Default value : 1
  %     Range value : -Inf to Inf
  %   intercept - Intercept of linear transform
  %     Default value : 0
  %     Range value : -Inf to Inf
  %   marker - Chosen Marker (on shape)
  %     Default value : -
  %
  %Usage:
  %%Marker 1
  %add_marker(subpop{2},'Myosin','Red');
  %(...)
  %%Marker 2
  %add_marker(subpop{2},'Actin','Green');
  %
  %%In this case we have the green marker depend on the the red one, and
  %%avoid it. This is done at a pixel level. If I is the intensity of the
  %%red marker at a pixel then the intensity of the green marker is:
  %%slope*I+intercept (where slope and intercept are specified below). A
  %%negative value of the slope implies supression.
  %
  %op=Locally_Dependant_Marker_Level();
  %
  %%The red marker strongly supresses the green one.
  %set(op,'slope',-100);
  %set(op,'intercept',0.8);
  %set(op,'marker',subpop{2}.markers.Myosin.cytoplasm);
  %subpop{2}.markers.Actin.cytoplasm.AddOperation(op);
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
    slope
    intercept
    marker
    region
    func
    description=['Constant marker level', ...
      ' dependant (linearly) on level of chosen marker on a specified region.', ...
      ' Output level is slope*F(marker_shape|region)+intercept. ', ...
      'F is the function (mean,median etc) calculated on marker'...
      ' restricted to region.'
      ];    
  end
  
  
  methods
    function obj=Locally_Dependant_Marker_Level()
      obj.slope=Parameter('Slope',1,SimuCell_Class_Type.number,...
        [-Inf,Inf],'Slope of linear transform');
      obj.intercept=Parameter('Intercept',0,SimuCell_Class_Type.number,...
        [-Inf,Inf],'Intercept of linear transform');
      obj.marker=Parameter('Marker',0,...
        SimuCell_Class_Type.simucell_marker_model,...
        [],'Chosen Marker (on shape)');
    end    
    
    function result=Apply(obj,current_marker,current_shape_mask,...
        other_cells_mask,needed_shapes,needed_markers)
      other_marker=needed_markers{1};
      %masked_marker=other_marker(current_shape_mask);
      current_marker=zeros(size(current_shape_mask));
      temp=min(max(obj.slope.value*other_marker+obj.intercept.value,0),1);
      current_marker(current_shape_mask)=temp(current_shape_mask);
      result=current_marker;
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list={obj.marker.value};
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list=cell(0);
    end
    
  end
  
  
end
