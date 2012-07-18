classdef Marker<dynamicprops
%Marker class used to define a Marker
%
%Marker Properties:
%   color - the color used to display the marker
%     value   : a Color value (e.g., 'Red'), see available value in class
%     Colors.
%
%Usage:
%%Marker 1
%add_marker(subpop{1},'Actin','Green');
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
  
  
  properties % (SetAccess=private)
    color
  end
  
  
  methods
    
    function obj=Marker(varargin)
      obj.color=Colors.Red;
      if(nargin>0)
        props=properties(varargin{1});
        for i=1:length(props)
          obj.addprop(props{i});
          obj.(props{i})=Marker_Operation_Queue;
        end
        if(nargin>1)
          [~,valid_color_names]=enumeration('Colors');
          if(isa(varargin{2},'Colors') ||...
              ismember(varargin{2},valid_color_names))
            obj.color=varargin{2};
          else
            error([varargin{2} ' is not a valid color definition']);
          end
        end
      end
    end
    
  end
  
  
end

