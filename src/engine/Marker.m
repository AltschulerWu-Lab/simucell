classdef Marker<dynamicprops
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
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
                    [valid_colors,valid_color_names]=enumeration('Colors');
                    if(ismember(varargin{2},valid_colors) | ismember(varargin{2},valid_color_names))
                        obj.color=varargin{2};
                    else
                        error([varargin{2} ' is not a valid color definition']);
                    end
                end
            end
        end
    end
    
end

