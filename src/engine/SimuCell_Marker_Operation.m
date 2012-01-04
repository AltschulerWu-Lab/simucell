classdef SimuCell_Marker_Operation <SimuCell_Model
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
%         number_of_parameters
%         default_values
%         description
%         parameters
         needed_shape_list
         prerendered_marker_list
    end
    
    methods (Abstract)
%         function obj= SimuCell_Object(parameters)
%             obj.parameters=parameters;
%         end

        Apply(numeric);
    end
    
end

