function cof=ml_calcobjcof(obj)
%ML_CALCOBJCOF Calculate COF of an object.
%   COF = ML_CALCOBJCOF(OBJ) calculate COF of an object. The object is 
%   a matrix with 2 columns or 3 columns. The first two columns are X and
%   Y coordinates. The third column is the vector of gray levels, which
%   are all ones if the third column does not exist.

%   27-JUN-2004 Initial write T. Zhao
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

if size(obj,2)==2
    cof(1)=mean(obj(:,1));
    cof(2)=mean(obj(:,2));   
else
    cof(1)=sum(obj(:,1).*obj(:,3))/sum(obj(:,3));
    cof(2)=sum(obj(:,2).*obj(:,3))/sum(obj(:,3));
end
