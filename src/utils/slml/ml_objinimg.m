function idx = ml_objinimg(obj,imgsize)
%ML_OBJINIMG Test if an object has pixels outside of an image.
%   IDX = ML_OBJINIMG(OBJ,IMGSIZE) returns the indices of points in the
%   [object] or [point array] which are outside of an image with image size
%   IMGSIZE. 
%   
%   See also

%   15-May-2006 Initial write T. Zhao
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

if nargin < 2
    error('Exactly 2 arguments are required')
end

idx = find(obj(:,1)<1 | obj(:,2)<1 | ...
    obj(:,1)>imgsize(1) | obj(:,2)>imgsize(2));
