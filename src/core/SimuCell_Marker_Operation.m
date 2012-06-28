classdef SimuCell_Marker_Operation <SimuCell_Model
%SIMUCELL_MARKER_OPERATION   The template class from which all plugins
%for markers are derived. Each plugin defines a single operation,
%and a series of operation is performed sequentially to set the final
%marker distribution.
%
%SimuCell_Marker_Operation methods:
%  Apply - A function that returns the intensity of the marker at
%    every pixel in the image after application of the marker operation.
%  needed_shape_list - A function that returns a cell array containing
%    all the other objects (nuclei, cells etc) that are required by
%    the make_shape function. Each element is  of type SimuCell_Object.
%    This function is used internally by the engine to determine the
%    order in which objects should be drawn.
%  prerendered_marker_list - A function that returns a cell array
%    containing all the other markers (defined on a specific shape) that
%    are required by the Apply function. Each element of the cell is  of
%    type Marker_Operation_Queue. This function is used internally by
%    the engine to determine the order in which markers should be
%    rendered.
%
%See also  SimuCell_Model, Constant_Dependant_Marker_Level,Perlin_texture
%
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
  end
  
  
  methods (Abstract)
    Apply(numeric);
    prerendered_marker_list(numeric);
    needed_shape_list(numeric);
  end
  
  
end

