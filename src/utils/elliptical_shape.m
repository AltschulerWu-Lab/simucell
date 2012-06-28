function[out] = elliptical_shape(radius,eccentricity,variation)
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.SimuCell.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%
if(radius~=round(radius))
    if(rand()<(radius-floor(radius)))
        radius=ceil(radius);
    else
        radius=floor(radius);
    end
end


step = 0.1;
t = (0:step:1)'*2*pi;


t1 = variation.*(2*rand(size(t))-1)+sin(t);
t2 = sqrt(1-eccentricity^2)*(variation.*(2*rand(size(t))-1)+cos(t));
t1(end) = t1(1);
t2(end) = t2(1);

theta=2*pi*rand();
rotmat=[cos(theta) -sin(theta); sin(theta) cos(theta)];
object = [t2';t1'];
object=rotmat*object;

pp_nuc = cscvn(object);
object = ppval(pp_nuc, linspace(0,max(pp_nuc.breaks),500));
	
object = radius*object;

object(1,:) = object(1,:) - min(object(1,:));
object(2,:) = object(2,:) - min(object(2,:));
object = round(object)+1;

I = zeros(max(round(object(1,:))),max(round(object(2,:))));
BW = roipoly(I,object(2,:),object(1,:));
out = BW;
