classdef SimuCell_Model <hgsetget
%SIMUCELL_MODEL Template abstract class for all simucell models
%  Template abstract class for all simucell models, so everything can
%  be be derived from this class.
%  property set and get interface.  hgsetget is a subclass of handle, so
%  any classes derived from hgsetget are handle classes.
%  classdef MyClass < SimuCell_Model makes MyClass a subclass of
%  SimuCell_Model.
%  Classes that are derived from hgsetget inherit property description 
%  and do inherit methods SET that perform a check to see if the value is a
%  PARAMETER .
%
%SIMUCELL_MODEL methods:
%  SET - Set MATLAB object property values performing a check to see
%    if the value is a PARAMETER .
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
  
  
  properties (Abstract)
    description
  end
  
  
  methods
    
    function obj= set(obj,varargin)
      p = inputParser;
      p.KeepUnmatched = true;
      p.parse(varargin{:});
      chosen_fields=fieldnames(p.Unmatched);      
      for i=1:length(chosen_fields)
        %Following works only from Matlab version 2011a, not before
        %if(isprop(obj,chosen_fields{i}))
        %So replaced by:
        if any(strcmp(chosen_fields{i}, properties(obj)))
          if(isa(obj.(chosen_fields{i}),'Parameter'))
            obj.(chosen_fields{i}).value=p.Unmatched.(chosen_fields{i});
          else
            obj.(chosen_fields{i})=p.Unmatched.(chosen_fields{i});
          end
        else
          error([chosen_fields{i} ' is not a valid property']);
        end
      end
      for i=1:length(chosen_fields)
        if(isa(obj.(chosen_fields{i}),'Parameter'))          
          notify(obj.(chosen_fields{i}),'Parameter_Set');
        end
      end
    end
    
  end
  
  
end

