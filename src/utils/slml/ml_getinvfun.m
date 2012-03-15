function fi = ml_getinvfun(f)
%ML_GETINVFUN Get the inverse function of a function.
%   FI = ML_GETINVFUN(F) returns a [general function] which represents the
%   inverse function of the [general function] F.
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


if nargin < 1
    error('Exactly 1 argument is required');
end

fnames = {'sqrt','ml_sqr','exp','log','ml_comfun','ml_comfun', ...
    'ml_div2','ml_mult2','ml_linfun','ml_linfun', ...
    'ml_projball2','ml_invprojball2','ml_pcatrans','ml_invpcatrans'};

idx = strmatch(f.funname,fnames,'exact');
if isempty(idx)
    error('Unrecognized function name.');
else
    idx = idx(1);
    if mod(idx,2)==1
        fi.funname = fnames{idx+1};
    else
        fi.funname = fnames{idx-1};
    end
end

if strcmp(f.funname,'ml_comfun')==1
    nfun = length(f.param);
    for i=1:nfun
        fi.param{nfun-i+1} = ml_getinvfun(f.param{i});
    end
else
    if isfield(f,'param')
        switch f.funname
            case 'ml_linfun'
                fi = ml_getinvlinfun(f);
            otherwise
                fi.param = f.param;
        end
        
    end
end

if isfield(f,'nvar')
    fi.nvar = f.nvar;
end

if isfield(f,'transform')
    if isfield(f.transform,'input')
        fi.transform.output = ml_getinvfun(f.transform.input);
    end
    
    if isfield(f.transform,'output')
        fi.transform.input = ml_getinvfun(f.transform.output);
    end
    
    if isfield(f.transform,'xscale')
        warning('You are using old version of function');
        fi.transform.yscale = 1./f.transform.xscale;
        if isfield(f.transform,'xtransl')
            fi.transform.ytransl = ...
                -f.transform.xtransl./f.transform.xscale;
        end
    else
        
        if isfield(f.transform,'xtransl')
            warning('You are using old version of function');
            fi.transform.ytransl = -f.transform.xtransl;
        end
    end

    if isfield(f.transform,'yscale')
        warning('You are using old version of function');
        fi.transform.xscale = 1./f.transform.yscale;
        if isfield(f.transform,'ytransl')
            fi.transform.xtransl = ...
                -f.transform.ytransl./f.transform.yscale;
        end
    else
        if isfield(f.transform,'ytransl')
            warning('You are using old version of function');
            fi.transform.xtransl = -f.transform.ytransl;
        end
    end
end
