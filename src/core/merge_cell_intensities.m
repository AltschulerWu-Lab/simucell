function merged_image=merge_cell_intensities(cell_intensity_list,new_weight)

%MERGED_CELL_INTENSITIES  function
%  [MERGED_IMAGE] = MERGED_CELL_INTENSITIES(CELL_INTENSITY_LIST,NEW_WEIGHT)
%
%   The CELL_INTENSITY_LIST parameter .
%   The NEW_WEIGHT parameter .
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

number_of_cells=length(cell_intensity_list);
mask_existing=false(size(cell_intensity_list{1}));
merged_image=zeros(size(cell_intensity_list{1}));
for cell_number=1:number_of_cells
  mask_new=cell_intensity_list{cell_number}>0;
  overlap_area=mask_existing&mask_new;
  nonoverlap_area=(~mask_existing&mask_new);
  merged_image(nonoverlap_area)=cell_intensity_list{cell_number}(nonoverlap_area);
  merged_image(overlap_area)=new_weight*cell_intensity_list{cell_number}(overlap_area)...
    +(1-new_weight)*merged_image(overlap_area);  
  mask_existing=mask_existing|mask_new;
end
