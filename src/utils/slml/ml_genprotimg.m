function protimage = ml_genprotimg(protmodel,nucedge,celledge,param)
%ML_GENPROTIMG Generate protein image from a protein model.
%   PROTIMAGE = ML_GENPROTIMG(PROTMODEL,NUCEDGE,CELLEDGE) returns an image of
%   the protein with the generative model PROTMODEL. NUCEDGE and CELLEDGE are 
%   binary images for defining the compartments. NUCEDGE represents nuclear
%   boundary and CELLEDGE represents cell boundary.
%   
%   PROTIMAGE = ML_GENPROTIMG(PROTMODEL,NUCEDGE,CELLEDGE,PARAM) also sepcifies
%   how to generate the images by the structure PARAM, which has the following
%   fields:
%       'imageSize' - image size. The default value is the size of NUCEDGE.
%       'loc' - which compartment/compartements are considered. See 
%           ML_CELLDISTCODE for more details. The default value is 'all'.
%   
%   See also

%   14-Jan-2007 Initial write T. Zhao
%   Copyright (c) 2007 Murphy Lab
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

%nucedge = double(nucedge);
%celledge = double(celledge);

if nargin < 3
    error('3 or 4 arguments are required');
end

if ~exist('param','var')
    param = struct([]);
end

param = ml_initparam(param,struct('imageSize',size(nucedge), ...
    'loc','all','minv',1,'minmeth','redraw'));

protimage = zeros(param.imageSize);

[distcodes,coords,angles] = ...
    ml_celldistcode(celledge,nucedge,{},1,param.loc);

sumdists = sum(abs(distcodes(:,1:2)),2);
if any(sumdists==0)
    rmidx = find(sumdists==0);
    distcodes(rmidx,:) = [];
    coords(rmidx,:) = [];
    angles(rmidx,:) = [];
    sumdists(rmidx,:) = [];
end

normdists = distcodes(:,1)./sumdists;

if ~isfield(protmodel.positionModel,'transform')
    x = [ones(size(normdists,1),1) normdists angles angles.^2];
else
    x = ml_evalfun([normdists angles], ...
                   protmodel.positionModel.transform);
end

if isnumeric(protmodel.positionModel.beta)
    idx = randperm(size(protmodel.positionModel.beta,2));
    idx = idx(1);
    beta = protmodel.positionModel.beta(:,idx);
else
    beta = ml_rnd(protmodel.positionModel.beta);
    beta = beta';
end

ps = ml_evallogistic(x,beta);
ps = ps/sum(ps);
objnum = round(ml_rnd(protmodel.objectModel.numStatModel));
while objnum==0
    objnum = round(ml_rnd(protmodel.objectModel.numStatModel));
end

ey = ml_mnornd(objnum,ps',1);

ecof = coords(ey==1,1:2);
        
gaussObjects = {};
needsRotation = 0;

while length(gaussObjects)<size(ecof,1)
    newSigma = ml_rnd(protmodel.objectModel.stat);
    
    switch param.minmeth
        case 'replace'
            newSigma(newSigma<param.minv) = param.minv;
        case 'redraw'
            if any(newSigma<param.minv)
                continue
            end
        otherwise
            error(['Unrecognized minimal method:' param.minmeth]);
    end
    
    if length(newSigma)==1 %spherical
        v = newSigma;
        newSigma = [newSigma 0;0 newSigma];
    else                   %full/diagonal
        needsRotation = 1;
        v = sqrt(newSigma(1)*newSigma(2));
        newSigma = [newSigma(1) 0;0 newSigma(2)];
    end

    %do not consider small variances
%     if newSigma(1)<0.15 | newSigma(4)<0.15
%         continue
%     end

    %Generate a gaussian object
    gaussObject = ml_gaussobj(newSigma);

    %train intensity model
    if isfield(protmodel.objectModel,'intensStatModel')
        intensity = ml_rnd( ...
            protmodel.objectModel.intensStatModel);
        if isfield(protmodel.objectModel,'relation')
            invtransfun = ml_getinvfun( ...
                protmodel.objectModel.relation);
            intensity = ...
                ml_evalfun({intensity,v},invtransfun);
        end

        gaussObject(:,3) = ...
            gaussObject(:,3)*intensity/sum(gaussObject(:,3));
    end
    
    gaussObjects{end+1} = gaussObject;
end
        
for i=1:size(ecof,1)
    object = gaussObjects{i};
    if needsRotation
        object = tz_rotateobj(object,unifrnd(0,360));
    end
    
    protimage = ml_imaddobj2(protimage,object,...
        struct('method','add','pos',ecof(i,:)));
end

%keyboard
