function pts=ml_getlinept2(s,a,len,isend)
%ML_GETLINEPT2 Get coordinates of points on a line segment.
%   ML_GETLINEPT2(S,A,LEN) returns coordinates of points on a line segment
%   with starting point S, angle A and length LEN.
%   
%   ML_GETLINEPT2(S,A,LEN,ISEND) only returns the two ends of the line
%   segment if ISEND is 1. Otherwise, it is the same as
%   ML_GETLINEPT2(S,A,LEN).

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

if nargin < 3
    error('3 or 4 arguments are required');
end

if ~exist('isend','var')
    isend=0;
end

a=mod(a,360);
len=round(len);

switch a
case 0
    t=[s(1)+len,s(2)];
case 90
    t=[s(1),s(2)+len];
case 180
    t=[s(1)-len,s(2)];
case 270
    t=[s(1),s(2)-len];
otherwise
    ra=a*pi/180;
    t=round([s(1)+cos(ra)*len,s(2)+sin(ra)*len]);
end

if isend
    pts=[s;t];
else
    pts=ml_getlinept(s,t);
end
