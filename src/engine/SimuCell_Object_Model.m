classdef SimuCell_Object_Model <SimuCell_Model
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Abstract)
%         number_of_parameters
%         default_values
%         description
%         parameters
         
    end
    
    methods (Abstract)
%         function obj= SimuCell_Object(parameters)
%             obj.parameters=parameters;
%         end

        make_shape(numeric);
        obj_list=prerendered_object_list(SimuCell_Object);
    end
    
    
end

