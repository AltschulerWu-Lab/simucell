function subp_num=discrete_prob(subp_probs)
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.SimuCell.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%    
    if(size(subp_probs,1)>1)
      subp_probs=subp_probs';
    end
    r=rand;
    pvec=[0 subp_probs];
    cp=cumsum(pvec);
    cp1=[cumsum(subp_probs) 1];
    
    subp_num=find((cp<r)&(cp1>r),1);

end

