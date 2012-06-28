classdef SimuCell_CellArtifact_Operation <SimuCell_Model
%SIMUCELL_CELLARTIFACT_OPERATION   The template class from which all
%plugins for adding artifacts to individual cells are derived.
%
%SIMUCELL_CELLARTIFACT_OPERATION methods:
%  Apply - A function that returns a a cell array(# cells(biological) ,#
%    markers). Each element of the cell is a matrix
%    (image_height,image_width).
%    The value of each element of this matrix is the pixel intensity of
%    one marker on one cell.
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
  
  
  properties    
  end
  
  
  methods (Abstract)
    Apply(numeric);
  end
  
  
end
