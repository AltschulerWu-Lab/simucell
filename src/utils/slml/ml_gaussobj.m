function obj = ml_gaussobj(sigma)
%ML_GAUSSOBJ An object from Gaussian distribution.
%   OBJ = ML_GAUSSOBJ(SIGMA) returns an object that is extracted from a
%   2D Gaussian distribution which has covariance matrix SIGMA. The object
%   contains no less than 95% energy of the Gaussian distribution.
%   
%   See also

%   26-Jan-2006 Initial write T. Zhao
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

img = ml_gaussimg(sigma);

y = ml_wquantile(img(:),0.95);
img(img<y) = 0;

imageSize = size(img);

[r,c]=find(img>0);
obj = [r,c,img(sub2ind(imageSize,r,c))];