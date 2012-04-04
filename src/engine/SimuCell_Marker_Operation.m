classdef SimuCell_Marker_Operation <SimuCell_Model
    %SIMUCELL_MARKER_OPERATION   The template class from which all plugins
    % for markers are derived. Each plugin defines a single operation,
    % and a series of operation is performed sequentially to set the final marker distribution. 
    % 
    %SimuCell_Marker_Operation methods:
    %       Apply     - A function that returns the intensity of the marker at every pixel 
    %       in the image after application of the marker operation. 
    %       needed_shape_list    - A function that returns a cell array
    %       containing all the other objects (nuclei, cells etc) that are
    %       required by the make_shape function. Each element is  of type
    %       SimuCell_Object. This function is used internally by the engine to
    %       determine the order in which objects should be drawn.
    %       prerendered_marker_list     - A function that returns a cell array
    %       containing all the other markers (defined on a specific shape) that are
    %       required by the Apply function. Each element of the cell is  of type
    %       Marker_Operation_Queue. This function is used internally by the engine to
    %       determine the order in which markers should be rendered.
    %
    %   See also  SimuCell_Model,
    %   Constant_Dependant_Marker_Level,Perlin_texture
    %   
    %
    %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab  
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

