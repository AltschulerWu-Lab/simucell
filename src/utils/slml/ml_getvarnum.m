function n = ml_getvarnum(f)
%ML_GETVARNUM Returns the number of variables of the function.
%   N = ML_GETVARNUM(F) returns the number the variables of the 
%   [general function] F.
%   
%   See also

%   04-Aug-2006 Initial write T. Zhao
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

if isfield(f,'nvar')
    n = f.nvar;
else
    if ml_iscomposite(f)
        nfun = length(f.param);
        n = 1;
        for i=1:nfun
            nvar = ml_getvarnum(f.param{i});
            if nvar>n
                n = nvar;
            end
            
        end
        
    else
        n = 1;
    end
    
end


