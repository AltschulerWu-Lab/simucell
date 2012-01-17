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
                    obj.color=varargin{2};
                end
            end
        end
    end
    
end

