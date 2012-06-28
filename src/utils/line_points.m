function output=line_points(x1,y1,x2,y2,sz)
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
r=floor(sqrt((x1-x2).^2+(y1-y2).^2));
dx=(x2-x1)/r;
dy=(y2-y1)/r;
output=zeros(r,2);
for i=1:r
    output(i,1)=round(x1+dx*i);
    output(i,2)=round(y1+dy*i);
end
output=sub2ind(sz,output(:,1),output(:,2));
end
