classdef SimuCell_Class_Type
%SIMUCELL_CLASS_TYPE   The template class from which all
%plugins for adding artifacts to individual cells are derived.
%
%SIMUCELL_CLASS_TYPE enumeration:
%  SimuCell type allowed for plugin's arguments.
%    -number: A integer or double
%    -simucell_shape_model: any SimuCell_Object_Model object that you can
%      find in plugins/shape/
%    -simucell_marker_model: any Marker_Operation_Queue containing
%      objects from plugins/marker. Defne a marker on a shape done by a
%      series of operations.
%    -list: any kind of list, usually string list.
%    -file_name: a file path (used to load SLML MATLAB files).
%
%See also  SimuCell_Model,Cell_Staining_Artifacts, Out_Of_Focus_Cells
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
  
    
    enumeration
        number,simucell_shape_model,simucell_marker_model,list,file_name
    end
end

