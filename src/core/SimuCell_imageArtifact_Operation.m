classdef SimuCell_imageArtifact_Operation <SimuCell_Model
  %SIMUCELL_IMAGEARTIFACT_OPERATION template class from which all
  %plugins for adding artifacts to an image are derived.
  %
  %SIMUCELL_IMAGEARTIFACT_OPERATION methods:
  %  Apply - function that returns a a cell array(#colors,1).
  %    Each element of the cell is a matrix(image_height,image_width).
  %    The value of each element of this matrix is the pixel intensity of
  %    all the cells(biological) for one color channel.
  %
  %   See also  SimuCell_Model,
  %   Add_Basal_Brightness, Linear_Image_Gradient
  %
  %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  %
  
  
  properties
  end
  
  
  methods (Abstract)
    Apply(numeric);
  end
  
  
end
