function y = ml_comfun(x,fs)
%ML_COMFUN Composite function.
%   Y = ML_COMFUN(X,FS) returns the value of X from the composite function
%   FS, which is the cell array of [general function]s.
%   If FS={f1,f2,f3,...} and it is univraite, then y=f3(f2(f1(x))).
%   If f2 is bivarate, then y=f3(f2(f1(x{1}),x{2})).
%   
%   See also

%   03-Aug-2006 Initial write T. Zhao
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

nfun = length(fs);

nvar = ml_getvarnum(struct('funname','ml_comfun','param',{fs}));

if nvar==1
    y = x;

    for i=1:nfun
        y = ml_evalfun(y,fs{i});
    end
else
    y = x{1};
    v2 = x{2};
    for i=1:nfun
        if ml_getvarnum(fs{i})==2
            y = ml_evalfun({y,v2},fs{i});
        else
            y = ml_evalfun(y,fs{i});
        end
        
    end
    
end

