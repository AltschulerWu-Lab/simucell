function img = ml_gaussimg(sigma)
%ML_GAUSSIMG Synthesize an image from a 2D Gaussian distribution.
%   IMG = ML_GAUSSIMG(SIGMA) returns an image that has intensities with
%   a 2D Gaussian distribution. SIGMA is the 2x2 covariance matrix of the 
%   Gaussian distribution.
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
    error('Exactly 1 arguments are required')
end

imageSize = round([6*sqrt(sigma(1,1)),6*sqrt(sigma(2,2))]);

x = ml_imcoords(imageSize,1,-round(imageSize/2))';
img = reshape(mvnpdf(x,[0 0],sigma),imageSize(1),imageSize(2));

