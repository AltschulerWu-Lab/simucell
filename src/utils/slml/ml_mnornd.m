function [R,s]=ml_mnornd(n,p,mm)
%ML_MNORND Generate multinoial random numbers.
%   R = ML_MNORND(N,P,M) returns a matrix of data sampled from a 
%   multinomial distribution, which has parameters N and P. N is the
%   number of multinomial trials and P is a vector of multinomial
%   coefficients, which has length K if it is K-nomial. The sum of P
%   must be 1. M samples will be generated and it results in a MxK
%   matrix for R.
%   
%   [R,S] = ML_MNORND(...) also returns the assignments for each sample.
%   
%   See also TZ_GSMIXRND
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


%   13-MAR-2004 Initial write T. Zhao
%   28-MAR-2004 Modified T. Zhao
%   24-JUN-2004 Modified T. Zhao
%       - consider float error of p
%   12-JAN-2006 Modified T. Zhao
%       - fix the return value bug (return K+1 columns for K-nomial)
%   Copyright (c) Center for Bioimage Informatics, CMU

if nargin < 3
    error('Exactly 3 arguments are required')
end

m=length(p);

if any(p<0) | abs(sum(p)-1)>0.0001
    warning('invalid p');
    R=repmat(NaN,mm,m);
    s=0;
    return
end

if m==1
    R=binornd(n,p,mm,1);
    R=[R,n-R];
    return
end
s=[];
for j=1:mm
    cp=[0,cumsum(p)];
    x=unifrnd(0,1,[n 1]);
    r=zeros(1,m);
    temps=[];
    for i=1:n
        catx=find(cp(1:end-1)<x(i) & cp(2:end)>=x(i));
        r(catx)=r(catx)+1;
        temps=[temps,catx];
    end
    R(j,:)=r;
    s=[s;temps];
end



