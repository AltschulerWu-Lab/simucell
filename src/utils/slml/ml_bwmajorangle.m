function [theta,center]=ml_bwmajorangle(img)
%ML_BWMAJORANGLE The major angle of the binary version of an image.
%   THETA = ML_BWMAJORANGLE(IMG) returns the angle of the major axis of
%   the binary version of the 2D image IMG. This means that the major
%   angle is calculated on the binary image in which a pixel is one if and
%   only if the corresponding pixel in IMG has value greater than 0. This
%   function also considers skewness of the image. The unit of the THETA
%   is radian.
%   
%   [THETA,CENTER] = ML_BWMAJORANGLE(...) also returns the center of the
%   binary image.
%   
%   See also

%   ??-???-???? Initial TINGZ T. Zhao
%   30-OCT-2004 Modified T. Zhao
%       - add comments
%   23-Mar-2004 Modified T. Zhao
%       - Debugged 
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

img=img>0;

mom = ml_bwmoment(img);

center=[mom.cx,mom.cy];

theta = .5 * atan((mom.mu02 - mom.mu20)/2/mom.mu11)+sign(mom.mu11)*pi/4;%+pi/2;

ntheta=[cos(theta),sin(theta)];
[x,y]=find(img>0);
imgskew=skewness([x,y]*ntheta');
if imgskew<0
    theta=theta+pi;
end

% img=imrotate(img, -theta*180./pi, 'bilinear', 'loose');
% 
% mom = tz_bwmoment(img);
% dmass=sum(sum(img(1:round(mom.cx-1),:),2)>0);
% umass=sum(sum(img(round(mom.cx+1):end,:),2)>0);
% 
% if umass<dmass
%     theta=theta+pi;
% end

