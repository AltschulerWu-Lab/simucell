classdef SimuCell_Compositing_Model<SimuCell_Model
%SimuCell_Compositing_Model   The template class from which all plugins
%for defining object models (shapes of cells, nuclei) are defined.
%
%SimuCell_Compositing_Model methods:
%  calculate_compositing_matrix - A function that returns a matrix
%    containing describing how object the marker level overlap between
%    the different objects.
%
%USED BY THE ENGINE EXCLUSIVELY, DEFINED BY THE COMPOSITING PLUGINS
%
%See also  SimuCell_Model, Centered_Nucleus_Model, SLML_Nucleus_Model
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
    object_compositing_matrix=calculate_compositing_matrix(cell);
  end
  
  
end
