classdef Default_Compositing<SimuCell_Compositing_Model
  %Default_Compositing compositing plugin used to manage the marker
  %level overlap between the different objects (e.g. nucleus, mitochondria,
  %etc...) within a cell.
  %
  %Default_Compositing Properties:
  %   container_weight    - weight of the container (e.g. a cell) while the
  %   contained (e.g. nucleus, nuclear body) is given (1 - weight).
  %     Default value : 0
  %     Range value   : 0 to 1
  %
  %Usage:
  %subpop{2}.compositing=Default_Compositing();
  %set(subpop{2}.compositing,'container_weight',0.3);
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
    description =['Decide how the marker level overlap between the'...
      ' different objects (e.g. nucleus, mitochondria, etc...)'...
      ' within a cell. When one object contains another (e.g., cell), then on'...
      ' the contained (e.g. nucleus), the container will be given a weight,'...
      ' while the contained is given 1 - weight'];
    container_weight
  end
  
  
  methods
    
    function obj=Default_Compositing()
      obj.container_weight=Parameter('Weight Given To Container',...
        0,SimuCell_Class_Type.number,...
        [0,1],['When one object contains another, then on the'...
        ' contained object, the container will be given this weight,'...
        ' while the contained is given 1- this weight']);
    end
    
    function object_compositing_matrix=calculate_compositing_matrix(obj,...
        object_masks)
      [number_of_cells,number_of_objects]=size(object_masks);
      object_compositing_matrix=0.5*ones(number_of_objects);
      for obj1=1:number_of_objects
        for obj2=1:number_of_objects
          is_contained=true;
          for cell_number=1:number_of_cells
            if(nnz((~object_masks{cell_number,obj1})&object_masks{cell_number,obj2})>0)
              is_contained=false;
            end
          end
          if(is_contained)
            object_compositing_matrix(obj1,obj2)=obj.container_weight.value;
            object_compositing_matrix(obj2,obj1)=1-obj.container_weight.value;
          end
          if(obj1==obj2)
            object_compositing_matrix(obj2,obj1)=1;
          end
        end
      end
    end
    
  end
  
  
end
