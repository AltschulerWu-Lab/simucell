function [distcodes,coords,angles] = ...
    ml_celldistcode(celledge,nucedge,objects,isbin,loc)
%ML_CELLDISTCODE Coding pixels by their distaces to cell and nuclues edge.
%   DISTCODES = ML_CELLDISTCODE(CELLEDGE,NUCEDGE,OBJECTS,ISBIN) returs a
%   3-column matrix DISTCODES. Each row of DISTCODES has the form
%   [[nucleus distance,cell distance,gray level]. CELLEDGE and NUCEDGE are
%   [image]s for cell edge and nuclues edge. OBJECTS is the one-level cell
%   array of objects or an [image]. Each object is a 2-column or 3-colomn
%   matrix.
%   If ISBIN is one, the the last column of DISTCODES will be binarized.
%   
%   ML_CELLDISTCODE(CELLEDGE,NUCEDGE,OBJECTS,ISBIN,LOC) specifies what
%   regions are coded:
%       'cyt' - cytoplasm
%       'nuc' - nucleus
%       'all' - whole cell
%
%   [DISTCODES,COORDS,ANGLES] = ML_CELLDISTCODE(...) also returns the 
%   coordinates.
% Copyright (C) 2007  Murphy Lab
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

 
%   22-OCT-2004 TINGZ Initial write T. Zhao
%   Copyright (c) Murphy Lab, Carnegie Mellon University

if nargin < 4
    error('4 or 5arguments are required')
end

if ~exist('loc','var')
    loc = 'cyt';
end


if any(size(celledge)~=size(nucedge))
    error('sizes of edge images do not match');
end

%fill the edges
cellimg=imfill(celledge,'hole');
nucimg=imfill(nucedge,'hole');

%Create object image
if ~isempty(objects)
    if iscell(objects)
        objimg=ml_objs2img(objects,size(celledge));
    else
        objimg=objects;
    end
    
    if isbin==1
        objimg=objimg>0;
    end
else
    objimg = zeros(size(celledge));
end


celldist = bwdist(celledge);
nucdist = bwdist(nucedge);
nucdist(nucimg==1) = -nucdist(nucimg==1);

%mask for coding
switch loc
    case 'cyt'
        codemask = double(cellimg)-double(nucimg);
    case 'nuc'
        codemask = double(cellimg)-double(cellimg);
    case 'all'
        codemask = double(cellimg);
    otherwise
        error(['unrecognized location name: ' loc]);
end

[I,J]=find(codemask==1);
coords = [I,J];
ind=sub2ind(size(codemask),I,J);

distcodes=[nucdist(ind),celldist(ind),objimg(ind)];

%Calculate angles
if nargout==3
    [center,mangle] = ml_edgecenter(nucedge);
    pt1 = center+[cos(mangle),sin(mangle)];
    pt2 = center;
    [th,r] = cart2pol(coords(:,1)-center(1),coords(:,2)-center(2));
    th = th-mangle;
    angles = ml_normangle(ml_normangle( ...
        ml_normangle(th,'r2a'),'360'),'a2r');
    
    %Old algorithm (slow)
    %for i=1:size(coords,1)
    %    angles2(i) = tz_findangle_2d(pt1,pt2,coords(i,:));
    %end
    %sum(abs(angles-angles2'))
end
