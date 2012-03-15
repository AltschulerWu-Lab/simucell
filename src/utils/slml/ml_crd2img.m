function img = ml_crd2img(pts,param)
%ML_CRD2IMG Convert coordinate shape into an image.
%   IMG = ML_CRD2IMG(PTS) returns an image that contains the [curve] PTS.
%   
%   IMG = ML_CRD2IMG(PTS,PARAM) specifies the parameters of convertion.
%   Currently it contains a field 'tz_obj2img' which has two subfields, 
%   'imgsize' and 'mode'. These two subfileds are parameters for 2nd and
%   3rd arguments for the function ML_OBJ2IMG. 
%   
%   See also

%   31-Dec-2005 Initial write T. Zhao
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

if nargin < 1
    error('1 or 2 arguments are required')
end

if ~exist('param','var')
    param = struct([]);
end

obj2imgParameters.imgsize = [];
obj2imgParameters.mode = [];
param = ml_initparam(param,struct('tz_obj2img',obj2imgParameters));
pts = ml_showpts_2d(pts,'ln',0);
img = ml_obj2img(pts,param.tz_obj2img.imgsize,param.tz_obj2img.mode);

