function pts2 = ml_moldshape(pts,dists)
%ML_MOLDSHAPE Relocate points according to the distance difference.
%   PTS2 = ML_MOLDSHAPE(PTS,DISTS) returns an array of points that are form
%   the points PTS, which are relocated according to the distance
%   differences DISTS. PTS and DISTS must have the same number of rows.
%   
%   See also

%   11-Apr-2005 Initial write  T. Zhao
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

if nargin < 2
    error('Exactly 2 arguments are required')
end 

[tmp,s]=min(abs(pts(pts(:,1)>0,2)));

if s>1
    tpts=[pts(s:end,:);pts(1:s-1,:)];
else
    tpts=pts;
end
orgdists=sqrt(sum(tpts.^2,2));
rdist = (orgdists+dists)./orgdists;
pts2(:,1)=tpts(:,1).*rdist;
pts2(:,2)=tpts(:,2).*rdist;

% [th,r]=cart2pol(pts(:,1),pts(:,2));
% r = r+dists;
% [pts2(:,1),pts2(:,2)] = pol2cart(th,r);