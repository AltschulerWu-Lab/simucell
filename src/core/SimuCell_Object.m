classdef SimuCell_Object <hgsetget
%SIMUCELL_OBJECT   class representing any simucell object
%  class reprensenting all simucell object/shape (like a nucleus,
%  cytoplasm, nuclear body etc... ), so everything can
%  be be derived from this class.
%  property set and get interface.  hgsetget is a subclass of handle, so
%  any classes derived from hgsetget are handle classes.
%
%  classdef MyClass < SimuCell_Object makes MyClass a subclass of 
%  SimuCell_Object.
%
%  Classes that are derived from hgsetget inherit property description
%  and do inherit methods SET that perform a check to see if the value is
%  a PARAMETER.
%
%  SIMUCELL_MODEL methods:
%    SET - Set MATLAB object property values performing a check to
%    see if the value is a PARAMETER .
%
%  See also hgsetget
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
    model;
  end
  
  
  methods
    
    function obj=SimuCell_Object()
      obj.model=[];
    end
    
  end
  
  
end
