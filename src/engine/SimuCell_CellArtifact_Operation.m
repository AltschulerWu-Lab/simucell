classdef SimuCell_CellArtifact_Operation <SimuCell_Model
    %SIMUCELL_CELLARTIFACT_OPERATION   The template class from which all plugins for
    % adding artifacts to individual cells are derived.
    % 
    %SIMUCELL_CELLARTIFACT_OPERATION methods:
    %       Apply     - A function that returns a a cell array(# cells(biological) ,#
    %       markers). Each element of the cell is a matrix(image_height,image_width). 
    %       The value of each element of this matrix is the pixel intensity of
    %       one marker on one cell.
    %
    %   See also  SimuCell_Model,Cell_Staining_Artifacts,
    %   Out_Of_Focus_Cells
    %
    %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab    
    properties

    end
    
    methods (Abstract)
        Apply(numeric);
        
    end
    
end
