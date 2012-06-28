function optimal_order=dependancy_resolution(dependancy_matrix)

%DEPENDANCY_RESOLUTION  Based on a dependancy matrix return the optimal
%order to run.
%  [OPTIMAL_ORDER] = DEPENDANCY_RESOLUTION(DEPENDANCY_MATRIX)
%   displays a dialog box for the user to fill in and returns the
%   filename and path strings and the index of the selected filter.
%   A successful return occurs if a valid filename is specified. If an
%   existing filename is specified or selected, a warning message is
%   displayed. The user may select Yes to use the filename or No to
%   return to the dialog to select another filename.
%
%   The DEPENDANCY_MATRIX parameter .
%
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

number_of_nodes=size(dependancy_matrix,1);
optimal_order=[];
for node_num=1:number_of_nodes
  resolved=[];
  seen=[];
  [resolved,seen]=dep_rec(dependancy_matrix,node_num,resolved,seen);
  for i=resolved
    if(nnz(optimal_order==i)==0)
      optimal_order=[optimal_order, i];
    end
  end
end

  function [resolved,seen]=dep_rec(dependancy_matrix,node_num,resolved,seen)
    connected_nodes=find(dependancy_matrix(node_num,:));
    seen=[seen,node_num];
    for node1=connected_nodes
      if(nnz(resolved==node1)==0)
        if(nnz(seen==node1)~=0)
          error([' Dependancies cannot be resolved. Circular:' num2str(node_num),' ' num2str(node1)] );
        end
        [resolved,seen]=dep_rec(dependancy_matrix,node1,resolved,seen);
      end
    end
    
    resolved=[resolved, node_num];
    
  end
end
