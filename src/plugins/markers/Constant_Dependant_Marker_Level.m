classdef Constant_Dependant_Marker_Level <SimuCell_Marker_Operation
  %Constant_Dependant_Marker_Level marker plugin used constant
  %marker level dependant (linearly) on level of chosen marker on a
  %specified region.
  %Output level is slope*F(marker_shape|region)+intercept.
  %F is the function (mean,median etc) calculated on marker restricted to
  %region
  %If x_(m,r) is the mean level in of marker m in region r, then
  %this plugin sets the intensity of chosen marker in chosen region to be:
  %slope*x_(m,r) + intercept
  %
  %Constant_Dependant_Marker_Level Properties:
  %   slope - Slope of linear transform. Slope in the equation above,
  %   negative sign means inverse relation
  %     Default value : 1
  %     Range value   : -Inf,Inf
  %   intercept - Intercept of linear transform. Intercept in equation
  %   above. This is the level the marker will have if the other 
  %   marker x_(m,r) is zero
  %     Default value : 0
  %     Range value   : -Inf,Inf
  %   marker - Chosen Marker (on shape)> The other marker i.e. m on which
  %   this marker depends
  %     Default value : -
  %   region - Region on which marker is calculated
  %     Default value : -
  %   func - Function calculated on specified marker over specified region.
  %   Returns a single number
  %     Default value : 'Mean'
  %     Available values   : 'Mean','Median','Max','Min'
  %
  %Usage:
  % %The level of this marker in a cell is inversely correlated with the
  % %presence of the Red 'menv' marker. This is achieved using the
  % %'Constant_Dependant_Marker_Level' plugin.
  % %It sets the marker level in to a constant, with the value of this
  % %constant being varying with the mean level of another marker.
  %
  % op=Constant_Dependant_Marker_Level();
  %
  % %If x_(m,r) is the mean level in of marker m in region r, then
  % %this plugin sets the intensity of chosen marker in chosen region to
  % %be: slope*x_(m,r) + intercept
  % %slope in the equation above, negative sign means inverse relation
  % set(op,'slope',-2.5);
  %
  % %Intercept in equation above. This is the level the marker will have
  % %if the other marker x_(m,r) is zero
  % set(op,'intercept',0.9);
  %
  % %The other marker i.e. m on which this marker depends
  % set(op,'marker',subpop{1}.markers.menv.cytoplasm);
  %
  % %The region on which m is calculated i.e. r
  % set(op,'region',subpop{1}.objects.cytoplasm);
  % set(op,'func','Mean');
  %
  % %The last three lines specify that the mean level of the menv marker
  % %measured on the cytoplasmic region will be used to determine the
  % %level of GFP.
  %
  % subpop{1}.markers.GFP.cytoplasm.AddOperation(op);
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
      'F is the function (mean,median etc) calculated on marker restricted to region'
      ];
  end
  
  
  methods
    function obj=Constant_Dependant_Marker_Level()
      obj.slope=Parameter('Slope',1,SimuCell_Class_Type.number,...
        [-Inf,Inf],'Slope of linear transform');
      obj.intercept=Parameter('Intercept',0,...
        SimuCell_Class_Type.number,...
        [-Inf,Inf],'Intercept of linear transform');
      obj.marker=Parameter('Marker',0,...
        SimuCell_Class_Type.simucell_marker_model,...
        [],'Chosen Marker (on shape)');
      obj.region=Parameter('Region',0,...
        SimuCell_Class_Type.simucell_shape_model,...
        [],'Region on which marker is calculated');
      obj.func=Parameter('Function','Mean',SimuCell_Class_Type.list,...
        {'Mean','Median','Max','Min'},...
        ['Function calculated on specified marker over specified'...
        ' region. Returns a single number']);
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,...
        other_cells_mask,needed_shapes,needed_markers)
      shape_mask=needed_shapes{1};
      other_marker=needed_markers{1};
      masked_marker=other_marker(shape_mask);
      switch obj.func.value
        case 'Mean'
          level=mean(masked_marker(:));
        case 'Median'
          level=median(masked_marker(:));
        case 'Max'
          level=max(masked_marker(:));
        case  'Min'
          level=min(masked_marker(:));
      end
      level=min(max(obj.slope.value*level+obj.intercept.value,0),1);
      current_marker(current_shape_mask)=level;
      result=current_marker;
    end
    
    function pre_list=prerendered_marker_list(obj)
      pre_list={obj.marker.value};
    end
    
    function pre_list=needed_shape_list(obj)
      pre_list={obj.region.value};
    end
    
  end
  
  
end
