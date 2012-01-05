classdef SimuCell_Marker_Operation <SimuCell_Model
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%         number_of_parameters
%         default_values
%         description
%         parameters
         
    end
    
    methods (Abstract)
%         function obj= SimuCell_Object(parameters)
%             obj.parameters=parameters;
%         end

        Apply(numeric);
        prerendered_marker_list(numeric);
        needed_shape_list(numeric);
    end
    
end

