function x = ml_rnd(f,param)
%ML_RND Random sampling.
%   X = ML_RND(F) return one data point randomly sampled from the [pdf] F.
%
%   X = ML_RND(F,N) returns N data points.
%
%   X = ML_RND(F,PARAM) specifies how many data will be sampled and how to
%   sample the data if more then one sampling methods are available.
%   PARAM is a structure with the follow fields:
%       'n' - number of the samples      
%   
%   See also ML_PDF ML_ESTPDF

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
    error('At least 1 argument is required');
end

if ~exist('param','var')
    param = struct([]);
end

if isnumeric(param)
    param = struct('n',param);
end

param = ml_initparam(param,struct('n',1));

switch f.name
    case 'trunc'
        cdf1 = ml_cdf(f.a2,f.comppdf) - ml_cdf(f.a1,f.comppdf);
        n2 = round(param.n/cdf1);
        x = [];
        while n2>0
            y = ml_rnd(f.comppdf,n2);
            y(y<f.a1 | y>f.a2) = [];
            x = [x;y];
            n2 = round((param.n-length(x))/cdf1);
        end
        x = x(1:param.n);
    case 'norm'      
        x = normrnd(f.mu,f.sigma,param.n,1);
    case 'hist'
        rnd = ml_mnornd(param.n,f.hist(:,end)',1);
        idx = find(rnd>0);
        num = rnd(idx);
        allidx = [];
        for i=1:length(num)
            allidx = [allidx;zeros(num(i),1)+idx(i)];
        end
        x = f.hist(allidx(randperm(length(allidx))),1:end-1);
    case 'mvn'
        x = mvnrnd(f.mu,f.sigma,param.n);
    case 'gamma'
        x = gamrnd(f.alpha,f.beta,param.n,1);
    case 'exp'
        x = exprnd(f.beta,param.n,1);  
    case 'mix'
        ns = ml_mnornd(param.n,f.ps,1);
        x = [];
        for i=1:length(f.ps)
            x = [x;ml_rnd(f.pdfs{i},struct('n',ns(i)))];
        end
        x = x(randperm(param.n)',:);
    case 'bicond'
        x(:,1) = ml_rnd(f.pdf1,param);
        x(:,2) = ml_evalfun({ml_rnd(f.pdf2,param),x(:,1)}, ...
                            ml_getinvfun(f.relation));
    otherwise
        error('Unrecognized pdf.');
end

if isfield(f,'transform')
    x = ml_evalfun( x, ml_getinvfun(f.transform) );
end
