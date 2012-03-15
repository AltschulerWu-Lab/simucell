function img = model2img2( models, param )
% MODEL2SLML Synthesizes a single multicolor image from a set of SLML Level 1.0
% Version 1.* instances.
%
% Input arguments           Descriptions
% ---------------           ------------
% model{s}                  A set of SLML instances
% param                     A structure containing the mandatory or optional
%                           function parameters
%
% List Of Parameters        Description
% ------------------        -----------
% param.verbose (optional) Prints steps and useful information to screen. If this variable
%                           is not a field, then the default is param.verbose = false.
% param.synthesize         A vector of length(models) that tells the method
%                           which patterns to return. If this variable is not a field, then the
%                            default is param.synthesize = eyes(N,1)+2 where N=length(models).
% param.images             A cell array containing the absolute or relative paths
%                           to images that will be used by the system as synthesized
%                           images. 
%
% Example 1
% ---------
% If we assume length(models)=N, then the next call will return a single multicolor image where
% the nuclear shape and cell shape model where synthesized using models{1} as well as a protein 
% pattern for each model in models.
% > img = model2img( models, [] );
%
% Example 2
% ---------
% > params.verbose = false;
% > params.synthesize = [1,0,0];
% > params.images = { '' '' '' '' };
% > model2img2( model, params );

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: 2/9/2012 (icaoberg@cmu.edu)
%
% Copyright (C) 2012  Murphy Lab
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

if nargin == 1
   param.verbose = false;
   param.synthesize=ones(size(models));
   param.images = {};
end

if length(models)+2 ~= length(param.synthesize) 
   error( ['SLML Toolbox: size mismatch between models and param.synthesize']);
end

nucEdge = param.images{1};
cellEdge = param.images{2};

if ~isempty(nucEdge) & ~isempty(cellEdge) & ( size(nucEdge) ~= size(cellEdge) )
    error('SLML Toolbox: nuclear and cell edge must have the same size');
end

if nargin > 2
   error( 'SLML Toolbox: Wrong number of input arguments.' );
end

param = ml_initparam(param, ...
    struct('imageSize',[1024 1024],'gentex',0,'loc','all'));

if length(models) == 1
    if ~isempty( nucEdge ) & ~isempty( cellEdge )
        %generate cell framework
        [nucEdge,cellEdge] = ml_gencellcomp( models, param );
    end

    %generate each protein pattern
    protimage = ml_genprotimg( models.proteinModel, nucEdge, cellEdge, param );

    %post-process each channel
    se=strel('disk',4,4);
    cellimage = imdilate(cellEdge,se);
    if ~exist('nuctex','var')
        nucimage = imdilate(nucEdge,se);
    else
        nucimage = nucEdge;
    end

   protimage = ml_bcimg(double(protimage),[],[0 1]);
    
    %add channels into a single image
    img = [];
    img(:,:,1) = nucimage;
    img(:,:,2) = cellimage;
    img(:,:,3) = protimage;
    img = img( find(param.synthesize==1) );
else
    if ~isempty( nucEdge ) & ~isempty( cellEdge )
       %generate cell framework
       [nucEdge,cellEdge] = ml_gencellcomp( models{1}, param );
    end

    %generate each protein pattern
    protimage = [];
    for i=1:1:length(models)        
         protimage{i} = ...
            ml_genprotimg( models{i}.proteinModel, nucEdge, cellEdge, param );
    end

    %post-process each channel
    se=strel('disk',4,4);
    cellimage = imdilate(cellEdge,se);
    if ~exist('nuctex','var')
        nucimage = imdilate(nucEdge,se);
    else
        nucimage = nucEdge;
    end

    %add channels into a single image
    img = [];
    img(:,:,1) = ml_bcimg(double(nucimage),[],[0 1]);
    img(:,:,2) = ml_bcimg(double(cellimage),[],[0 1]);
    for j=1:1:length(protimage)
        img(:,:,2+j) = ml_bcimg(double(protimage{j}),[],[0 1]);
    end
    img = img( find(param.synthesize==1) );
end
end%model2img
