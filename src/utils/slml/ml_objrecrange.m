function range=ml_objrecrange(obj)
%ML_OBJRECRANGE Minimal rectangle enclosing an object.
%   RANGE = ML_OBJRECRANGE(OBJ) returns a 1xM vector, of which each column
%   is the expansion of corresponding column of the object OBJ, which is a
%   NxM matrix, where N is the number of pixels and M is the number of
%   dimensions.
%   
%   See also

%   18-Sep-2005 Initial write T. Zhao
%   Copyright (c) Murphy Lab, Carnegie Mellon University

% range(1)=max(obj(:,1))-min(obj(:,1))+1;
% range(2)=max(obj(:,2))-min(obj(:,2))+1;
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

range=max(obj,[],1)-min(obj,[],1)+1;
