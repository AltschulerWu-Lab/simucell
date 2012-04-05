classdef SimuCell_Object_Model <SimuCell_Model
  %SIMUCELL_object_model   The template class from which all plugins for
  % defining object models (shapes of cells, nuclei) are defined.
  %
  %SIMUCELL_OBJECT_MODEL methods:
  %  make_shape     - A function that returns a binary
  %    mask(image_height,image_width) of the shape of the object
  %    being drawn.
  %  prerendered_object_list - A function that returns a cell array
  %    containing all the other objects (nuclei, cells etc) that are
  %    required by the make_shape function. Each element is  of type
  %    SimuCell_Object. This function is used internally by the engine to
  %    determine the order in which objects should be drawn.
  %
  %   See also  SimuCell_Model,
  %   Centered_Nucleus_Model, SLML_Nucleus_Model
  %
  %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
    
  
  methods (Abstract)    
    make_shape(numeric);
    obj_list=prerendered_object_list(SimuCell_Object);
  end
  
  
end

