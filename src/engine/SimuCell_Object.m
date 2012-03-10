classdef SimuCell_Object <hgsetget
%SIMUCELL_OBJECT   Template abstract class for all simucell models
%   Template abstract class for all simucell object (like a nucleus,
%   cytoplasm, nuclear body etc... ), so everything can
%   be be derived from this class.
%   property set and get interface.  hgsetget is a subclass of handle, so 
%   any classes derived from hgsetget are handle classes.  
%
%   classdef MyClass < SimuCell_Object makes MyClass a subclass of SimuCell_Object.
%
%   Classes that are derived from hgsetget inherit property description and 
%   do inherit methods SET that perform a check to see if the value is a
%   PARAMETER .
%
%   SIMUCELL_MODEL methods:
%       SET      - Set MATLAB object property values performing a check to 
%       see if the value is a PARAMETER .
%
%   See also hgsetget
 
%   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab    
   properties
      model; 
   end
   
   methods
      function obj=SimuCell_Object() 
          obj.model=[];
      end
   end
end