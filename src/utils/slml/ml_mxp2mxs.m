function shape2 = ml_mxp2mxs(shape)
%ML_MXP2MXS Conver medial axis spline into medial axis.
%   SHAPE2 = ML_MXP2MXS(SHAPE) returns the medial axis representation of
%   the shape which is originally represented by spline shape SHAPE.
%   
%   See also

%   31-Dec-2005 Initial write T. Zhao
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

x=(0:shape.length-1)/(shape.length-1);

shape2.format = 'mxs';
shape2.medaxis = [(1:shape.length)',spval(shape.spmedaxis,x)'];
shape2.width = spval(shape.spwidth,x);

