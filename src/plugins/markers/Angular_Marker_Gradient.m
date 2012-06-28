classdef Angular_Marker_Gradient <SimuCell_Marker_Operation
  %Angular_Marker_Gradient marker plugin used to scale intensities by an
  %angular gradient on image in random direction.
  %
  %Angular_Marker_Gradient Properties:
  %   center - Point with respect to which angles are measured
  %     Default value : 'Centroid'
  %     Available Values : 'Centroid','Furthest From Edge','Random'
  %   angular_width - Angular Width Of High Intesity Region
  %     Default value : 30
  %     Range value   : 0 to 360
  %   falloff_type - Functional form to calculate intensity fall-off
  %     Default value : 'Linear'
  %     Available Values: 'Linear','Exponential','Sigmoidal'
  %   min_multiplier - Min value multiplying the input intensities
  %     Default value : 0
  %     Range value   : 0 to Inf
  %   max_multiplier - Max value multiplying the input intensities
  %     Default value : 1
  %     Range value   : 0 to Inf
  %
  %Usage:
  % add_marker(subpop{2},'Myosin','Green');
  %
  %op=Angular_Marker_Gradient();
  %set(op,'center','Furthest From Edge');
  %set(op,'angular_width',30);
  %set(op,'falloff_type','Exponential');
  %set(op,'min_multiplier',0);
  %
  %subpop{2}.markers.Myosin.cytoplasm.AddOperation(op);
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
    center
    angular_width
    falloff_type
    max_multiplier
    min_multiplier
    description=['Scale intensities by an angular gradient'...
      ' on image in random direction.'];
  end
  
  
  methods
    
    function obj=Angular_Marker_Gradient()
      obj.center=Parameter('Angle Measured From','Centroid',...
        SimuCell_Class_Type.list,...
        {'Centroid','Furthest From Edge','Random'},...
        'Point with respect to which angles are measured');
      obj.angular_width=Parameter('Angular Width (degrees)',...
        30,SimuCell_Class_Type.number,...
        [0,360],'Angular Width Of High Intesity Region');
      obj.falloff_type=Parameter('Intensity FallOff Type',...
        'Linear',SimuCell_Class_Type.list,...
        {'Linear','Exponential','Sigmoidal'},...
        'Functional form to calculate intensity fall-off');
      obj.min_multiplier=Parameter('Min Intensity Scaling',...
        0,SimuCell_Class_Type.number,...
        [0,Inf],'Min value multiplying the input intensities');
      obj.max_multiplier=Parameter('Max Intensity Scaling',1,...
        SimuCell_Class_Type.number,...
        [0,Inf],'Max value multiplying the input intensities');
    end
    
    function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
      [row,col]=find(current_shape_mask);
      selected_region=current_marker(min(row):max(row),min(col):max(col));
      selected_mask=current_shape_mask(min(row):max(row),min(col):max(col));
      [xres,yres]=size(selected_region);
      [X,Y]=meshgrid(1:yres,1:xres);
      switch obj.center.value
        case 'Centroid'
          [row,col]=find(selected_mask);
          x=mean(row);
          y=mean(col);
        case 'Furthest From Edge'
          dists=bwdist(~full(selected_mask));
          [~,I]=max(dists(:));
          [x,y]=ind2sub([xres,yres],I);
        case 'Random'
          [row,col]=find(selected_mask);
          i=randsample(length(row),1);
          x=row(i);y=col(i);
      end
      theta=2*pi*rand();
      X1=cos(theta)*(X-x)-sin(theta)*(Y-y);
      Y1=sin(theta)*(X-x)+cos(theta)*(Y-y);
      z=180*abs(atan2(Y1,X1))/pi;
      switch obj.falloff_type.value
        case 'Linear'
        case 'Exponential'
          %Is this really ideal? What if cells have different sizes?
          z=exp(-z/(obj.angular_width.value));
        case 'gaussian'
          z=exp(-z.^2/(obj.angular_width.value)^2);
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
