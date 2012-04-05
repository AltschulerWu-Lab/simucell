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
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab

  
  methods (Abstract)
    object_compositing_matrix=calculate_compositing_matrix(cell);
  end
  
  
end