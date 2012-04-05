function overlap_acceptable=overlap_check(existing_object_masks,...
  current_mask,overlap_matrix,obj_num)

%OVERLAP_CHECK  function
%  [OVERLAP_ACCEPTABLE] = OVERLAP_CHECK(EXISTING_OBJECT_MASKS, 
%  CURRENT_MASK, OVERLAP_MATRIX, OBJ_NUM)
%
%   The EXISTING_OBJECT_MASKS parameter .
%   The CURRENT_MASK parameter .
%   The OVERLAP_MATRIX parameter .
%   The OBJ_NUM parameter .
%
%Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab

overlap_acceptable=true;
obj_to_compare=find(overlap_matrix(obj_num,:)~=1);
internal_overlap=0;
external_overlap=0;
for obj_num1=obj_to_compare
  existing_objects=existing_object_masks{obj_num1};
  number_of_existing_objects=length(existing_objects);
  areas_existing=zeros(number_of_existing_objects,1);
  area_current=nnz(current_mask);
  for i=1:number_of_existing_objects
    areas_existing(i)=nnz(existing_objects{i});
    if(nnz(size(existing_objects{i})==size(current_mask))~=2)
      disp('oops');
    end
    overlap_area=nnz(existing_objects{i}&current_mask);
    internal_overlap=max(overlap_area/area_current,internal_overlap);
    external_overlap=max(overlap_area/areas_existing(i),external_overlap);
    if(max(internal_overlap,external_overlap)>overlap_matrix(obj_num,obj_num1))
      overlap_acceptable=false;
      return;
    end
  end
end