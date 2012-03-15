function y = ml_evalfun(x,f,param)
%TZ_EVALFUN Evaluate a [parametric function].
%   Y = TZ_EVALFUN(X,F) returns the mapped values of X through the
%   [general function] F. The type of X depends on the function. If it
%   takes a vector or scalar value as a variable, then each row of X is a
%   sample of the variable. 
%   
%   Y = TZ_EVALFUN(X,F,PARAM) provides a way for function operation.
%   Currently scaling and translation are supported and they are only for
%   numeric fucntions. PARAM is a structure with the following two fields:
%       'transform' - transformation. It is also a structure with the following parameters:
%            'input' - input transform function, must be univariate
%            'output' - output transform function, must be univaraite
%       'outminor' - scale of the returned values
%
%       Notice: the scaling is done before translation
%
%   See also

%   10-Mar-2006 Initial write T. Zhao
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
    error('2 or 3 arguments are required')
end


if ~exist('param','var')   
    param = struct([]); 
end

param = ml_initparam(param,struct('outminor',0));

if ml_getvarnum(f)>1
    newx = x{1};
else
    newx = x;
end

    
if isfield(param,'transform')
    if isfield(param.transform,'input')
        newx = ml_evalfun(newx,param.transform.input);
    end
end

if isfield(f,'transform')
    if isfield(f.transform,'input')
        newx = ml_evalfun(newx,f.transform.input);
    end 
end

if ml_getvarnum(f)>1
    x = {newx,x{2:end}};
else
    x = newx;
end


if isfield(f,'param')
    if iscell(f.param) & strcmp(f.funname,'ml_comfun')==0
        cmd = [f.funname '(x,f.param{:})'];
    else
        cmd = [f.funname '(x,f.param)'];
    end
else
    cmd = [f.funname '(x)'];
end

%#function ml_invpcatrans ml_mappos ml_sqr ml_comfun ml_mult2
y = eval( cmd );

if isfield(f,'transform')
    if isfield(f.transform,'output')
        y = ml_evalfun(y,f.transform.output);
    end
end

if isfield(param,'transform')
    if isfield(param.transform,'output')
        newy = ml_evalfun(y,param.transform.output);
    end    
end

if param.outminor<0
    y = {y,x{2:end}};
else
    if param.outminor>0
        newy{1} = {y,x{2:param.outminor+1}};
        y = newy;
    end
end