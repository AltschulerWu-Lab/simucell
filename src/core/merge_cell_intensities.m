function merged_image=merge_cell_intensities(cell_intensity_list,new_weight)

%MERGED_CELL_INTENSITIES  function
%  [MERGED_IMAGE] = MERGED_CELL_INTENSITIES(CELL_INTENSITY_LIST,NEW_WEIGHT)
%
%   The CELL_INTENSITY_LIST parameter .
%   The NEW_WEIGHT parameter .
%
%Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab

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