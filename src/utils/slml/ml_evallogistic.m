function p=ml_evallogistic(x,para)
%ML_EVALLOGISTIC Probability of a logistic model.
%   P = TZ_EVALLOGISTIC(X,PARA) returns the probability of a logitic model with
%   the parameters PARA, in which each column is a set of parameters. X must 
%   be a [feature matrix] and the number of columns must be the same as the 
%   number of rows of PARA.
%   
%   See also

%   ??-OCT-2004 Initial write TINGZ
%   31-OCT-2004 Modified TINGZ
%       - add comments
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

y=x*para;

p=1./(1+exp(-y));
