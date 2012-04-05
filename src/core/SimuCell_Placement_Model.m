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
  %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  methods (Abstract)
    pos=pick_positions(numeric)
  end
  
  
end
