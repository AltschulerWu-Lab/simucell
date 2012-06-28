classdef SimuCell_ImageArtifact_Operation <SimuCell_Model
%SimuCell_ImageArtifact_Operation template class from which all
%plugins for adding artifacts to an image are derived.
%
%SimuCell_ImageArtifact_Operation methods:
%  Apply - function that returns a a cell array(#colors,1).
%    Each element of the cell is a matrix(image_height,image_width).
%    The value of each element of this matrix is the pixel intensity of
%    all the cells(biological) for one color channel.
%
%See also  SimuCell_Model,
%Add_Basal_Brightness, Linear_Image_Gradient
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
