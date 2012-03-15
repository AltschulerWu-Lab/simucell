function y = ml_mappos(x,param)
%ML_MAPPOS Map polar positions to another coordinate system.
%   Y = ML_MAPPOS(X) returns [1 X(1) X(1).^2 sin(X(2)) cos(X(2))]. Here X must
%   be a matrix with two columns. The first column represents radius and the 
%   second represents angle.
%   
%   Y = ML_MAPPOS(X,PARAM) specifies how to map the positions by the structure
%   PARAM, which could have the following fields:
%       'order' - polynomial order for radial coordinates. It must be a 
%           non-negative integer (default 2).
%       'scale' - components of harmonious functions. It must be a non-negative
%           integer (default 1).
%   
%   See also

%   14-Jan-2007 Initial write T. Zhao
%   Copyright (c) 2007 Murphy Lab
%   Carnegie Mellon University
%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published
%   by the Free Software Foundation; either version 2 of the License,
%   or (at your option) any later version.
%   
%   This program is distributed in the hope that it will be useful, but
%   WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
%   General Public License for more details.
%   
%   You should have received a copy of the GNU General Public License
%   along with this program; if not, write to the Free Software
%   Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
%   02110-1301, USA.
%   
%   For additional information visit http://murphylab.web.cmu.edu or
%   send email to murphy@cmu.edu


if nargin < 1
    error('1 or 2 arguments are required');
end

if ~exist('param','var')
   param = struct([]); 
end

param = ml_initparam(param,struct('order',2,'scale',1));

y = [];

if param.order>=0
    y = [y ones(size(x,1),1)];
end

if param.order>=1
    y = [y x(:,1)];
end

for k=2:param.order
    y = [y x(:,1).^k];
end

for k=1:param.scale
    y = [y sin(k*x(:,2)) cos(k*x(:,2))];
end


