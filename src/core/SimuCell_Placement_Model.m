classdef SimuCell_Placement_Model <SimuCell_Model
%SIMUCELL_PLACEMENT_MODEL   The template class from which all plugins for
% object (cells, nucleus etc) placement are derived.
%
%SIMUCELL_PLACEMENT_MODEL methods:
%       pick_positions      - A function that returns the position
%       where an object will be placed
%
%   See also  SimuCell_Model,Clustered_Placement, Random_Placement
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
  
  
  methods (Abstract)
    pos=pick_positions(numeric)
  end
  
  
end
