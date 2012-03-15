function [box,s] = ml_boundbox(pts)
%ML_BOUNDBOX Bounding box of points.
%   BOX = ML_BOUNDBOX(PTS) returns a 2x2 matrix which is the bounding box 
%   of the [point array] PTS. The first row of BOX is the left top corner
%   coordinate and the second row of BOX is the right bottom corner
%   coordinate. Here left,top,right,bottom is based on [image coordinate
%   system].
%
%   [BOX,S] = ML_BOUNDBOX(PTS) also returns the size of the bounding box.
%   S(1) is the height and S(2) is the width.
%
%   See also

%   20-Jan-2006 Initial write T. Zhao
%   Copyright (c) Center for Bioimage Informatics, CMU

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

topleft = min(pts,[],1);
bottomright = max(pts,[],1);

box = [topleft; bottomright];
s = box(2,:)-box(1,:)+[1 1];

