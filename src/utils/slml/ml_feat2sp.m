function sp = ml_feat2sp(knots,coefs)
%ML_FEAT2SP Convert knots and coeffents into B-spline
%   SP = ML_FEAT2SP(KNOTS,COEFS) returns a B-spline structure with internal
%   nodes KNOTS and coefficients COEFS.
%   
%   See also

%   28-Dec-2005 Initial write T. Zhao
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

sp.form = 'B-';
sp.coefs = coefs;
sp.number = length(coefs);
sp.order = length(coefs)-length(knots);
sp.dim = 1;
sp.knots = [zeros(1,sp.order) knots ones(1,sp.order)];
