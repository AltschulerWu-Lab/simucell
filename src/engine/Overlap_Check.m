function overlap_acceptable=Overlap_Check(existing_object_masks,current_mask,overlap_matrix,obj_num)

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
end