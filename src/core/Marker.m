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
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties (SetAccess=private)
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

