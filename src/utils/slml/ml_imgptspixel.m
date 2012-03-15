function ps=ml_imgptspixel(img,pts)
%ML_IMGPTSPIXEL Get pixel values at specified points.
%   PS = ML_IMGPTSPIXEL(IMG,PTS) returns a vector of pixel values from
%   the image IMG. PS(I) is the gray level of the pixel at position
%   [PTS(I,1),PTS(I,2)] in IMG.

%   ??-???-???? Initial write T. Zhao
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

imgsize=size(img);
pts(pts(:,1)<=0 | pts(:,1)>imgsize(1),:)=[];
pts(pts(:,2)<=0 | pts(:,2)>imgsize(2),:)=[];

if isempty(pts)
    error('empty points');
end

imgsize=size(img);

idx=sub2ind(imgsize,pts(:,1),pts(:,2));

ps=img(idx);
