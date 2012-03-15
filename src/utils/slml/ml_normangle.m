function a2=ml_normangle(a,option)
%ML_NORMANGLE Normalize an angle.
%   A2 = ML_NORMANGLE(A,OPTION) returns the normalized angle of A according 
%   to OPTION:
%       '180' - [0 180)
%       '360' - [0,360)
%       '90 - [0,90]
%       'a2r' - angle to radian
%       'r2a' - radian to angle

%   ??-OCT-2004 Initial write T. Zhao
%   01-NOV-2004 Modified T. Zhao
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

switch option
    case '180'  %[0 180)
        a2 = ml_normangle(a,'360');
        a2(a2>180) = 360-a2(a2>180);
    case '360' 
        a2=mod(a,360);  %[0,360)
    case '90'   %[0,90]
        a2=abs(a);
        a2=mod(a2,180);
        ri=find(a2>=90);
        if ~isempty(ri)
            a2(ri)=180-a2(ri);
        end
    case 'a2r'  %angle to radian
        a2=a*pi/180;
    case 'r2a'  %radian to angle
        a2=a*180/pi;
end
