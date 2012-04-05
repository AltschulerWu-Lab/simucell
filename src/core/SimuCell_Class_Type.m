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
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
    
    enumeration
        number,simucell_shape_model,simucell_marker_model,list,file_name
    end
end

