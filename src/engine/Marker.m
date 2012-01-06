classdef Marker<dynamicprops
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
      color
    end
    
    methods
        function obj=Marker(objects)
            props=properties(objects);
            for i=1:length(props)
               obj.addprop(props{i});
               obj.(props{i})=Marker_Operation_Queue;
            end
        end
    end
    
end

