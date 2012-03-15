function slml = slml2struct( filename )
%SLML2STRUCT Parses an XML into a Matlab structure the SLML instance

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: June 2, 2008
%
% Copyright (C) 2008 Center for Bioimage Informatics/Murphy Lab
% Carnegie Mellon University
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published
% by the Free Software Foundation; either version 2 of the License,
% or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
% 02110-1301, USA.
%
% For additional information visit http://murphylab.web.cmu.edu or
% send email to murphy@cmu.edu

if nargin ~= 1
    error('SLML Toolbox: Wrong number of input arguments');
elseif ~isaFile( filename )
    error('SLML Toolbox: The input argument is not an existing file');
elseif ~isSlmlInstanceValid( filename )
    error('SLML Toolbox: Input argument is not a valid SLML instance');
else
    %parse XML into a Matlab structure
    data = xml_read( filename );

    %get simple information
    if isfield( data.ATTRIBUTE, 'level' )
        slml.level = data.ATTRIBUTE.level;
    else
        %default
        slml.level = '1';
    end

    if isfield( data.ATTRIBUTE, 'version' )
        slml.version = data.ATTRIBUTE.version;
    else
        %default
        slml.version = '1.0';
    end

    if isfield( data.ATTRIBUTE, 'xmlns' )
        slml.namespace = data.ATTRIBUTE.xmlns;
    else
        %global namespace
        slml.namespace = 'http://murphylab.web.cmu.edu/services/SLML/level1';
    end

    %get SLML documentation
    if isfield( data, 'documentation' )
        slml.documentation = data.documentation;
    else
        slml.documentation = struct([]);
    end

    %get cell name
    if isfield( data.cell.ATTRIBUTE, 'name' )
        slml.cell.name = data.cell.ATTRIBUTE;
    else
        slml.cell.name = '';
    end

    %get model id
    if isfield( data.cell.model.ATTRIBUTE, 'id' )
        slml.cell.model.id = data.cell.model.ATTRIBUTE.id;
    end

    %get model name
    if isfield( data.cell.model.ATTRIBUTE, 'name' )
        slml.cell.model.name = data.cell.model.ATTRIBUTE.name;
    end

    %get nuclear shape model
    slml.cell.model.nuclearShapeModel.name = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(1).CONTENT;
    slml.cell.model.nuclearShapeModel.medaxis.name = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(2).parameter(1).CONTENT;
    slml.cell.model.nuclearShapeModel.medaxis.constknot = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(2).parameter(2).CONTENT;
    slml.cell.model.nuclearShapeModel.medaxis.nknots = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(2).parameter(3).CONTENT;
    slml.cell.model.nuclearShapeModel.medaxis.stat.name = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(2).parameter(4).parameter(1).CONTENT;
    slml.cell.model.nuclearShapeModel.medaxis.stat.mu = ...
        struct2vector( data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(2).parameter(4).parameter(2).vector );
    slml.cell.model.nuclearShapeModel.medaxis.stat.sigma = ...
        struct2array( data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(2).parameter(4).parameter(3).array.arrayrow );
    slml.cell.model.nuclearShapeModel.width.name = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(3).parameter(1).CONTENT;
    slml.cell.model.nuclearShapeModel.width.constknot = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(3).parameter(2).CONTENT;
    slml.cell.model.nuclearShapeModel.width.nknots = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(3).parameter(3).CONTENT;
    slml.cell.model.nuclearShapeModel.width.stat.name = ...
        data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(3).parameter(4).parameter(1).CONTENT;
    slml.cell.model.nuclearShapeModel.width.stat.mu = ...
        struct2vector( data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(3).parameter(4).parameter(2).vector );
    slml.cell.model.nuclearShapeModel.width.stat.sigma = ...
        struct2array( data.cell.model.listOfCompartments.compartment(1).object.shape.listOfParameters.parameter(3).parameter(4).parameter(3).array.arrayrow );


    %get cell shape model
    slml.cell.model.cellShapeModel.name = ...
        data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(1).CONTENT;
    slml.cell.model.cellShapeModel.startangle = ...
        data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(2).CONTENT;
    slml.cell.model.cellShapeModel.anglestep = ...
        data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(3).CONTENT;
    slml.cell.model.cellShapeModel.stat.name = ...
        data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(1).CONTENT;
    slml.cell.model.cellShapeModel.stat.mu = ...
        struct2vector( data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(2).vector );
    slml.cell.model.cellShapeModel.stat.sigma = ...
        struct2array( data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(3).array.arrayrow );
    slml.cell.model.cellShapeModel.stat.transform.funname = ...
        data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(4).parameter(1).CONTENT;
    slml.cell.model.cellShapeModel.stat.transform.param.ncomp = ...
        data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(4).parameter(2).parameter(1).CONTENT;
    slml.cell.model.cellShapeModel.stat.transform.param.basevec = ...
        struct2array( data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(4).parameter(2).parameter(2).array.arrayrow );
    slml.cell.model.cellShapeModel.stat.transform.param.offset = ...
        struct2vector( data.cell.model.listOfCompartments.compartment(2).object.shape.listOfParameters.parameter(4).parameter(4).parameter(2).parameter(3).vector );
    
    
    %get protein shape model
    slml.cell.model.proteinModel.proteinClass = ...
        data.cell.model.listOfCompartments.compartment(3).ATTRIBUTE.class;
    slml.cell.model.proteinModel.compartmentName = ...
        data.cell.model.listOfCompartments.compartment(3).ATTRIBUTE.name;
    slml.cell.model.proteinModel.proteinName = ...
        data.cell.model.listOfCompartments.compartment(3).ATTRIBUTE.protein;
    slml.cell.model.proteinModel.name = ...
        data.cell.model.listOfCompartments.compartment(3).parameter.CONTENT;
    
    slml.cell.model.proteinModel.objectModel.name = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(1).CONTENT;
    slml.cell.model.proteinModel.objectModel.covartype = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(2).CONTENT;
    slml.cell.model.proteinModel.objectModel.stat.name = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(3).parameter(1).CONTENT;
    slml.cell.model.proteinModel.objectModel.stat.beta = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(3).parameter(2).CONTENT;
    slml.cell.model.proteinModel.objectModel.stat.transform.funname = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(3).parameter(3).parameter.CONTENT;
    slml.cell.model.proteinModel.objectModel.relation.funname = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(4).parameter(1).CONTENT;
    slml.cell.model.proteinModel.objectModel.relation.nvar = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(4).parameter(2).CONTENT;
    slml.cell.model.proteinModel.objectModel.relation.param = ...
        { struct('funname', data.cell.model.listOfCompartments.compartment(3).object.parameter(4).parameter(3).parameter(1).parameter(1).CONTENT, ...
        'nvar', data.cell.model.listOfCompartments.compartment(3).object.parameter(4).parameter(3).parameter(1).parameter(2).CONTENT ) ...
        struct( 'funname', data.cell.model.listOfCompartments.compartment(3).object.parameter(4).parameter(3).parameter(2).parameter.CONTENT )};
    
    slml.cell.model.proteinModel.objectModel.intensStatModel.name = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(5).parameter(1).CONTENT;
    slml.cell.model.proteinModel.objectModel.intensStatModel.mu = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(5).parameter(2).CONTENT;
    slml.cell.model.proteinModel.objectModel.intensStatModel.sigma = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(5).parameter(3).CONTENT;
    
    slml.cell.model.proteinModel.objectModel.numStatModel.name = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(6).parameter(1).CONTENT;
    slml.cell.model.proteinModel.objectModel.numStatModel.alpha = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(6).parameter(2).CONTENT;
    slml.cell.model.proteinModel.objectModel.numStatModel.beta = ...
        data.cell.model.listOfCompartments.compartment(3).object.parameter(6).parameter(3).CONTENT;
   
    slml.cell.model.proteinModel.positionModel.name = ...
        data.cell.model.listOfCompartments.compartment(3).position.parameter(1).CONTENT;
    slml.cell.model.proteinModel.positionModel.beta = ...
        struct2array( data.cell.model.listOfCompartments.compartment(3).position.parameter(2).array.arrayrow );
    slml.cell.model.proteinModel.positionModel.transform.funname = ...
        data.cell.model.listOfCompartments.compartment(3).position.parameter(3).parameter(1).CONTENT;
    slml.cell.model.proteinModel.positionModel.transform.param.order = ...
        data.cell.model.listOfCompartments.compartment(3).position.parameter(3).parameter(2).parameter(1).CONTENT;   
    slml.cell.model.proteinModel.positionModel.transform.param.scale = ...
        data.cell.model.listOfCompartments.compartment(3).position.parameter(3).parameter(2).parameter(2).CONTENT;
end
end%slml2struct