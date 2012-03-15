function pts = ml_imcoords(imgsize,scale,offset)
%ML_IMCOORDS Coordinates of all pixels in an image.
%   PTS = ML_IMCOORDS(IMGSIZE) returns a 2x(MxN) matrix if IMGSIZE is
%   [M,N]. The coordinates are obtained column by column.
%
%   PTS = ML_IMCOORDS(IMGSIZE,SCALE) will rescale the coordinates by
%   1/SCALE.
%
%   PTS = ML_IMCOORDS(IMGSIZE,SCALE,OFFSET) will move the coordinates by 
%   OFFSET after scaling.

%   11-Sep-2005 Initial write T. Zhao

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
    error('At least 1 argument is required')
end

if nargin < 2
    scale = 1;
end

if nargin < 3
    offset = [0 0];
end

if length(scale)==1
    scale = zeros(1,2)+scale;
end

if(length(imgsize) ~= 2)
    error('The first argument must have exactly 2 elements');
end

xCoords = (1:imgsize(1))';
yCoords = 1:imgsize(2);

xPanel = xCoords( :,ones(imgsize(2),1) );
yPanel = yCoords(ones(imgsize(1),1),:);

pts = [xPanel(:)'/scale(1)+offset(1);yPanel(:)'/scale(2)+offset(2)];