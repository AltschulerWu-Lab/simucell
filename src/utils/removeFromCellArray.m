function newCellArray = removeFromCellArray(cellArray,row)
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
  if length(cellArray)==1
    newCellArray=cell(0);
    return;
  end
  newCellArray=cell(1,length(cellArray)-1);
  j=1;
  for i=1:length(cellArray)
    if(i~=row)
      newCellArray{j}=cellArray{i};
      j=j+1;
    end
  end
end

