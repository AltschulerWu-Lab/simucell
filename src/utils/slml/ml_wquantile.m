function y = ml_wquantile(x,p)
%ML_WQUANTILE Weighted quantile of a sample.
%   Y = ML_WQUANTILE(X,P) returns the P quantile of the weights in X, which 
%   is a row vector or column vector.
%   
%   See also

%   26-Jan-2006 Initial write T. Zhao
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

if nargin < 2
    error('Exactly 2 arguments are required')
end

if size(x,1)>1
    x = x';
end

[s,idx] = sort(x,2,'descend');

cs = cumsum(s);
cs = cs/cs(end)>p;
[tmp,sidx] = max(cs);

y = s(sidx);






