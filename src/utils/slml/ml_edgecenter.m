function [center,mangle] = ml_edgecenter(pts)
%ML_EDGECENTER Find the center of a contour.
%   CENTER = ML_EDGECENTER(EDGE) returns the center of a solid object which 
%   has edge specified by a [curve] or an [image]  EDGE. If the number of
%   columns of EDGE is 2, EDGE will be take as a [curve], otherwise it will
%   be taken as an [image].
%   
%   [CENTER,MANGLE] = ML_EDGECENTER(...) also returns the major angle of
%   the object. The unit is radian (same as the function TZ_BWMAJORANGLE).
%   
%   See also

%   24-Apr-2005 Initial write  T. Zhao
%   27-Jan-2006 Modified T. Zhao
%   Copyright (c) Murphy Lab, Carnegie Mellon University

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

if nargin < 1
    error('Exactly 1 argument is required')
end

if size(pts,2)==2
    conpts=ml_showpts_2d(round(pts),'ln',1);
    edgeimg=ml_obj2img(conpts,[]);
else
    edgeimg = pts;
end

objimg=imfill(edgeimg,'hole');

% center=imfeature(objimg,'Centroid');
[x,y]=find(objimg==1);
center=mean([x,y],1);

mangle=ml_bwmajorangle(objimg);

% center(1)=sum(pts(:,1).^2)/sum(pts(:,1));
% center(2)=sum(pts(:,2).^2)/sum(pts(:,2));
