function cellimg = model2cell(model, nucimg, param)
%MODEL2CELL Generate cell edge from a model.

%   14-Jan-2007 Initial write T. Zhao
%   Copyright (c) 2007 Murphy Lab
%   Carnegie Mellon University
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published
%   by the Free Software Foundation; either version 2 of the License,
%   or (at your option) any later version.
%   
%   This program is distributed in the hope that it will be useful, but
%   WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   General Public License for more details.
%   
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
%   02110-1301, USA.
%   
%   For additional information visit http://murphylab.web.cmu.edu or
%   send email to murphy@cmu.edu


if nargin < 1
    error('1 or 2 arguments are required');
end

if ~exist('param','var')
    param = struct([]);
end

param = ml_initparam(param,struct('imageSize',[1024 1024]));

nucImage

%generate cell shape
cellcode2 = ml_gencellshape(model.cellShapeModel,cellcode);
pts2 = cellcode2.nucellhitpts;
%Try again if the cell shape is too big
while (max(pts2(:,1))-min(pts2(:,1))>=param.imageSize(1)) | ...
        (max(pts2(:,2))-min(pts2(:,2))>=param.imageSize(2))
    cellcode2 = ml_gencellshape(model.cellShapeModel,cellcode);
    pts2 = cellcode2.nucellhitpts;
end

curve1 = cellcode2.nuchitpts;
curve2 = cellcode2.nucellhitpts;

cellBoundary = ml_showpts_2d(curve2,'ln',1);
nucBoundary = ml_showpts_2d(curve1,'ln',1);

[cellBoundbox,cellBoxsize] = ml_boundbox(cellBoundary);
offset = round((param.imageSize-cellBoxsize)/2)-cellBoundbox(1,:);

nucBoundary = ml_addrow(nucBoundary,offset);
cellBoundary = ml_addrow(cellBoundary,offset);

cellimg = ml_obj2img(cellBoundary,param.imageSize);
nucimg = ml_obj2img(nucBoundary,param.imageSize);
