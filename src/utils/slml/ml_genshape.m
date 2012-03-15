function shape = ml_genshape(shapemodel,param)
%ML_GENSHAPE Randomly generates a shape.
%   SHAPE = ML_GENSHAPE(SHAPEMODEL) returns a shape that is randomly
%   sampled from the statistical shape model SHAPEMODEL.
%   
%   SHAPE = ML_GENSHAPE(SHAPEMODEL,PARAM) spedifies the parameters for
%   generation. Currently it is only useful for 'act' model. The field is
%   'ncomp', which is the number of principal components for generation.
%   
%   See also tz_trainshapemodel

%   02-Jan-2006 Initial write T. Zhao
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

switch shapemodel.name
    case 'mxp'
        shape.format = 'mxs';
        %medfeat = mvnrnd(shapemodel.medmean,shapemodel.medcov,1);
        %widthfeat = mvnrnd(shapemodel.widthmean,shapemodel.widthcov,1);
        medfeat = ml_rnd(shapemodel.medaxis.stat);
        widthfeat = ml_rnd(shapemodel.width.stat);
        
        shape.length = round(medfeat(1));
        if isempty(shapemodel.medaxis.constknot)
            knots1 = medfeat(2:shapemodel.medaxis.nknots+1);
            coef1 = medfeat(shapemodel.medaxis.nknots+2:end);
        else
            knots1 = shapemodel.medaxis.constknot;
            coef1 = medfeat(2:end);
        end
        
        if isempty(shapemodel.width.constknot)
            knots2 = widthfeat(1:shapemodel.width.nknots);
            coef2 = widthfeat(shapemodel.width.nknots+1:end);
        else
            knots2 = shapemodel.width.constknot;
            coef2 = widthfeat(1:end);
        end
        
        shape.spmedaxis = ml_feat2sp(knots1,coef1);
        shape.spwidth = ml_feat2sp(knots2,coef2);
    case 'act'
        param = ml_initparam(param,struct('ncomp',5));
        shape.format = 'crd';
        ncom = param.ncomp;
        ss = shapemodel.avgshape(:)+shapemodel.pcvec(:,1:ncom)* ...
            mvnrnd(zeros(1,ncom),shapemodel.covmat(1:ncom,1:ncom),1)';
        shape.pts=[ss(1:360),ss(361:end)];
    otherwise
        error('Unrecognized shape model.');
end
