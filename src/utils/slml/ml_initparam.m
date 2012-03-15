function param = tz_initparam(param,paramdefault)
%TZ_INITPARAM Initialize parameters.
%   PARAM2 = TZ_INITPARAM(PARAM,PARAMDEFAULT) returns the initialized 
%   parameter. PARAM and PARAMDEFAULT are both structures. All fields
%   in PARAM will be kept unchanged in PARAM2. And all fields in
%   PARAMDEFAULT but not in PARAM will be added to PARAM2. If a field is a
%   structure, parameter initialization will go down herachically.
%   
%   Example:
%       param2 =  ml_initparam(struct('t',1,'t2',2),struct('t2',3,'t3',4))
%       returns
%           param2 = 
%               t: 1
%               t2: 2
%               t3: 4
%     
%       param2 =  ml_initparam(struct('t',1,'t2',struct('t3',2)), ...
%               struct('t1',3,'t2',struct('t4',4)))
%       returns
%           param2 = 
%               t: 1
%               t2: struct('t3',2,'t4',4)
%               t1: 3
%
%   See also

% Copyright (C) 2006  Murphy Lab
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

%   18-Nov-2005 Initial write T. Zhao
%   Copyright (c) Center for Bioimage Informatics, CMU

if nargin < 2
    error('Exactly 2 arguments are required')
end

if isempty(param)
    param = paramdefault;
    return;
end

defaultParameterNames = fieldnames(paramdefault);

for k=1:length(defaultParameterNames)
    defaultParameterValue = ...
        getfield(paramdefault,defaultParameterNames{k});
    if ~isfield(param,defaultParameterNames{k})
        param = setfield(param,defaultParameterNames{k}, ...
            defaultParameterValue);
    else
        if isstruct(defaultParameterValue)
            parameterValue = getfield(param,defaultParameterNames{k});
            param = setfield(param,defaultParameterNames{k}, ...
                ml_initparam(parameterValue,defaultParameterValue));
        end
    end
end
