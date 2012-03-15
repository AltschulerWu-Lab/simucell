function y = ml_invpcatrans(x,param)
%ML_INVPCATRANS Inverse PCA transformation.
%   Y = ML_INVPCATRANS(X,PARAM) returns coordinates in the original
%   coordinate system. See ML_PCANTRANS about PARAM.
%   
%   See also

%   02-Nov-2006 Initial write T. Zhao
%   Copyright (c) 2006 Murphy Lab
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


if nargin < 2
    error('Exactly 2 arguments are required');
end

param = ml_initparam( param,struct('offset',[]) );

y = x*param.basevec';

if ~isempty(param.offset)
    y = ml_addrow(y,param.offset);
end


