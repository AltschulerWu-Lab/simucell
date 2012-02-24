function [combined_channel_image,object_structure,full_result,marker_structure,combined_cell_images]=SimuCell_Engine(simucell_params)


number_of_subpopulations=length(simucell_params.subpopulations);
for subpop=1:number_of_subpopulations
    simucell_params.subpopulations{subpop}.calculate_shape_draw_order;
    simucell_params.subpopulations{subpop}.calculate_marker_draw_order;
end

simucell_params.overlap.construct_overlap_matrix(simucell_params.subpopulations);


subpopulation_number_of_cell=zeros(simucell_params.number_of_cells,1); %stores the subpopulation number of each cell
object_structure=struct; % stores the shape of every object in every cell. indexed by cell number

%generating cell-wise object shapes
current_image_mask=false(simucell_params.simucell_image_size);
cell_masks=cell(simucell_params.number_of_cells,1);

full_result=cell(length(simucell_params.overlap.ordered_shape_list),1);

for cell_number=1:simucell_params.number_of_cells
    current_cell=struct;
    subpopulation_number=discrete_prob(simucell_params.population_fractions); %replace by function with specified weights
    subpopulation_number_of_cell(cell_number)=subpopulation_number;
    
    draw_order=(simucell_params.subpopulations{subpopulation_number}.object_draw_order);
    number_of_objects=length(draw_order);
    
    overlap_acceptable=false;
    iteration_counter=0;
    while(~overlap_acceptable)
        overlap_acceptable=true;
        for object_number=1:number_of_objects
            prerendered_shapes_in_cell=cell(0);
            prerendered_shape_names=...
                simucell_params.subpopulations{subpopulation_number}.object_dependancy_struct.(draw_order{object_number});
            for i=1:length(prerendered_shape_names)
                prerendered_shapes_in_cell{i}=current_cell.(prerendered_shape_names{i});
            end
            pos=simucell_params.subpopulations{subpopulation_number}.placement.pick_positions(current_image_mask);
            shape=simucell_params.subpopulations{subpopulation_number}.objects.(draw_order{object_number}).model ...
                .make_shape([pos(1),pos(2)],current_image_mask,prerendered_shapes_in_cell);
            current_cell.(draw_order{object_number})=shape;
            obj_num=simucell_params.overlap.shape_to_number_map{subpopulation_number}(draw_order{object_number});
            if(~overlap_check(full_result,shape,simucell_params.overlap.overlap_matrix,obj_num))
                overlap_acceptable=false;
                %disp('check failed');
            end
        end
        
        iteration_counter=iteration_counter+1;
        if(iteration_counter>100)
            
            error('cannot fit in any more cells');
        end
    end
    shapes=fieldnames(current_cell);
    cell_masks{cell_number}=false(simucell_params.simucell_image_size);
    for i=1:length(shapes)
        current_image_mask=current_image_mask|current_cell.(shapes{i});
        cell_masks{cell_number}=cell_masks{cell_number}|current_cell.(shapes{i});
        object_structure(cell_number).(shapes{i})=sparse(current_cell.(shapes{i}));
        obj_num=simucell_params.overlap.shape_to_number_map{subpopulation_number}(shapes{i});
        full_result{obj_num}=[full_result{obj_num} {sparse(current_cell.(shapes{i}))}];
    end
    
    
end
final_mask=current_image_mask;

marker_structure=struct;
for cell_number=1:simucell_params.number_of_cells
    
    subpopulation_number=subpopulation_number_of_cell(cell_number);
    
    %draw_order=(simucell_params.subpopulations{subpopulation_number}.marker_draw_order);
    number_of_marker_shapes=length(simucell_params.subpopulations{subpopulation_number}.marker_draw_order_objects);
    %calculate mask from other cells
    other_cells_mask=false(simucell_params.simucell_image_size);
    for i=1:simucell_params.number_of_cells
        if(i~=cell_number)
            other_cells_mask=other_cells_mask|cell_masks{i};
        end
    end
    
    for marker_shape_counter=1:number_of_marker_shapes
        
        temp=simucell_params.subpopulations{subpopulation_number}.marker_draw_order_names{marker_shape_counter};
        marker_name=temp{1};
        shape_name=temp{2};
        operations=simucell_params.subpopulations{subpopulation_number}.marker_draw_order_objects{marker_shape_counter}.operations;
        number_of_operations=length(operations);
        current_marker=sparse(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
        for operation_number=1:number_of_operations
            op=operations{operation_number};
            needed_shapes=op.needed_shape_list();
            shapes_passed=cell(length(needed_shapes),1);
            for i=1:length(needed_shapes)
                shape_name1= simucell_params.subpopulations{subpopulation_number}.find_shape_name(needed_shapes{i});
                shapes_passed{i}=object_structure(cell_number).(shape_name1);
            end
            needed_marker_shapes=op.prerendered_marker_list();
            markers_passed=cell(length(needed_marker_shapes),1);
            for i=1:length(needed_marker_shapes)
                [marker_name1 shape_name1]=...
                    simucell_params.subpopulations{subpopulation_number}.find_marker_name(needed_marker_shapes{i});
                markers_passed{i}=marker_structure(cell_number).(shape_name1).(marker_name1);
            end
            current_shape_mask=object_structure(cell_number).(shape_name);
            current_marker=op.Apply(current_marker,current_shape_mask,...
                other_cells_mask,shapes_passed,markers_passed);
        end
        marker_structure(cell_number).(shape_name).(marker_name)=current_marker;
    end
end

%composite images
compositing_matrices=cell(number_of_subpopulations,1);
composite_cell_images=struct;
blurred_cell_images=struct;
for subpop=1:number_of_subpopulations
    cells_in_subpop=find(subpopulation_number_of_cell==subpop);
    shapes=properties(simucell_params.subpopulations{subpop}.objects);
    object_masks=cell(length(cells_in_subpop),length(shapes));
    for cell_number=1:length(cells_in_subpop)
        for shape_number=1:length(shapes)
            object_masks{cell_number,shape_number}=...
                object_structure(cells_in_subpop(cell_number)).(shapes{shape_number});
        end
    end
    compositing_matrices{subpop}=simucell_params.subpopulations{subpop}.compositing.calculate_compositing_matrix(object_masks);
    %     composite_cell_images()
    
    for cell_number=1:length(cells_in_subpop)
        %         composite=sparse(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
        weight_masks=cell(length(shapes),1);
        %         composite_mask=false(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
        number_shapes_overlapped=sparse(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
        for shape_number1=1:length(shapes)
            number_shapes_overlapped=number_shapes_overlapped+double(object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1}));
            weight_masks{shape_number1}=sparse(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
        end
        max_overlap=max(number_shapes_overlapped(:));
        
        for shape_number1=1:length(shapes)
            temp_mask=(number_shapes_overlapped==1)&object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1});
            weight_masks{shape_number1}(temp_mask)=compositing_matrices{subpop}(shape_number1,shape_number1);
            for shape_number2=1:shape_number1-1
                for overlap_number=2: max_overlap
                    temp_mask=(number_shapes_overlapped==overlap_number)&...
                        object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1})&...
                        object_structure(cells_in_subpop(cell_number)).(shapes{shape_number2});
                    weight_masks{shape_number1}(temp_mask)=weight_masks{shape_number1}(temp_mask)+...
                    compositing_matrices{subpop}(shape_number1,shape_number2)/nchoosek( overlap_number,2);
                end
            end
        end
        
        
%         number_shapes_overlapped(number_shapes_overlapped==1)=1;
%         for i=2:max(number_shapes_overlapped(:))
%             number_shapes_overlapped(number_shapes_overlapped==i)=1;%check expression
%         end
%         norm_matrix=zeros(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
%         for shape_number1=1:length(shapes)
%             
%             for shape_number2=1:shape_number1-1
%                 
%                 overlap_region=object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1})...
%                     & object_structure(cells_in_subpop(cell_number)).(shapes{shape_number2});
%                 only_shape1=~object_structure(cells_in_subpop(cell_number)).(shapes{shape_number2})...
%                     &object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1});
%                 only_shape2=~object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1})...
%                     &object_structure(cells_in_subpop(cell_number)).(shapes{shape_number2});
%                 either_shape=object_structure(cells_in_subpop(cell_number)).(shapes{shape_number1})...
%                     | object_structure(cells_in_subpop(cell_number)).(shapes{shape_number2});
%                 weight_masks{shape_number1}(overlap_region)=weight_masks{shape_number1}(overlap_region)+...
%                     compositing_matrices{subpop}(shape_number1,shape_number2)*number_shapes_overlapped(overlap_region);
%                 weight_masks{shape_number1}(only_shape1)=weight_masks{shape_number1}(only_shape1)+...
%                     number_shapes_overlapped(only_shape1);
%                 weight_masks{shape_number2}(overlap_region)=weight_masks{shape_number2}(overlap_region)+...
%                     compositing_matrices{subpop}(shape_number2,shape_number1)*number_shapes_overlapped(overlap_region);
%                 weight_masks{shape_number2}(only_shape2)=weight_masks{shape_number2}(only_shape2)+...
%                     number_shapes_overlapped(only_shape2);
% %                 norm_matrix(either_shape)=norm_matrix(either_shape)+1;
% %                 norm_matrix(overlap_region)=norm_matrix(overlap_region)+1;
%             end
%         end
%         for shape_number1=1:length(shapes)
%            norm_matrix=norm_matrix+weight_masks{shape_number1}; 
%         end
        markers=properties(simucell_params.subpopulations{subpop}.markers);
        
        for marker_number=1:length(markers)
            composite_cell_images(cells_in_subpop(cell_number)).(markers{marker_number})=...
                sparse(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2));
            for shape_number=1:length(shapes)
                composite_cell_images(cells_in_subpop(cell_number)).(markers{marker_number})=...
                    composite_cell_images(cells_in_subpop(cell_number)).(markers{marker_number})+...
                    weight_masks{shape_number}.*...
                    marker_structure(cells_in_subpop(cell_number)).(shapes{shape_number}).(markers{marker_number});
            end

        end
        
        
    end
    
    
    
    
    
    %Insert check for existance
    operation_list=simucell_params.subpopulations{subpop}.cell_artifacts;
    
    markers=properties(simucell_params.subpopulations{subpop}.markers);
    if(length(cells_in_subpop)>0)
        temp=cell(length(cells_in_subpop),length(markers));
        for marker_number=1:length(markers)
            for cell_number=1:length(cells_in_subpop)
                temp{cell_number,marker_number}=composite_cell_images(cells_in_subpop(cell_number)).(markers{marker_number});
            end
        end
        
        for op_number=1:length(operation_list)
            
            temp=operation_list{op_number}.Apply(temp);
        end
        
        
        for marker_number=1:length(markers)
            for cell_number=1:length(cells_in_subpop)
                
                blurred_cell_images(cells_in_subpop(cell_number)).(markers{marker_number})=temp{cell_number,marker_number};
            end
        end
    end
    
    
    
    
end

color_group_struct=calculate_color_groups(simucell_params.subpopulations);
color_names=fieldnames(color_group_struct);
combined_cell_images=struct;

for color_number=1:length(color_names)
    
    temp_intensity_list=cell(0);
    marker_list=color_group_struct.(color_names{color_number});
    counter=1;
    for i=1:size(marker_list,1)
        cells_in_subpop=find(subpopulation_number_of_cell==marker_list{i,1});
        for cell_number=1:length(cells_in_subpop)
            temp_intensity_list{counter}=blurred_cell_images(cells_in_subpop(cell_number)).(marker_list{i,2});
            counter=counter+1;
        end
    end
    
  
    combined_cell_images.(color_names{color_number})=Merge_cell_intensities(temp_intensity_list,0.85);
    
end

temp=cell(length(color_names),1);
for color_number=1:length(color_names)
    temp{color_number}= combined_cell_images.(color_names{color_number});
end

operation_list=simucell_params.image_artifacts;
for op_num=1:length(operation_list)
   temp=operation_list{op_num}.Apply(temp);
end

for color_number=1:length(color_names)
    combined_cell_images.(color_names{color_number})=temp{color_number};
end


combined_channel_image=zeros(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2),3);
for color_number=1:length(color_names)
   
    combined_channel_image(:,:,1)=  min(combined_channel_image(:,:,1)+Colors.(color_names{color_number}).R*...
        combined_cell_images.(color_names{color_number}),1);
    combined_channel_image(:,:,2)= min(combined_channel_image(:,:,2)+Colors.(color_names{color_number}).G*...
        combined_cell_images.(color_names{color_number}),1);
    combined_channel_image(:,:,3)=min(combined_channel_image(:,:,3) +Colors.(color_names{color_number}).B*...
        combined_cell_images.(color_names{color_number}),1);
end
% 
% 
% %assuming all cells have same markers for now
% marker_names=fieldnames(blurred_cell_images);
% combined_cell_images=struct;
% combined_channel_image=zeros(simucell_params.simucell_image_size(1),simucell_params.simucell_image_size(2),3);
% for marker_number=1:length(marker_names)
%     temp_intensity_list=cell(simucell_params.number_of_cells,1);
%     for cell_number=1:simucell_params.number_of_cells
%         temp_intensity_list{cell_number}=blurred_cell_images(cell_number).(marker_names{marker_number});
%     end
%     combined_cell_images.(marker_names{marker_number})=Merge_cell_intensities(temp_intensity_list,0.85);
%     combined_channel_image(:,:,marker_number)= combined_cell_images.(marker_names{marker_number});
% end
% 
% 

%
%final_image=zeros(image_size(1),image_size(2),number_of_markers);
%full_image_textures=cell(number_of_markers,number_of_cells,number_of_objects_per_cell);
%
%for marker_number=1:number_of_markers;
%    complete_composite=zeros(image_size);
%    for cell_number=1:number_of_cells
%        current_cell=full_image_structure(cell_number,:);
%        subpopulation_number=subpopulation_number_of_cell(cell_number);
%        current_cell_texture=squeeze(full_image_textures(:,cell_number,:));
%
%        for object_number=draw_order(subpopulation_number,:)
%            texture=zeros(image_size);
%            texture(current_cell{object_number})=1;
%            number_of_operations=length(subpopulations{subpopulation_number}.markers{...
%                marker_number}.operations{object_number});
%
%            for operation_number=1:number_of_operations
%                texture=subpopulations{subpopulation_number}.markers{...
%                    marker_number}.operations{object_number}{operation_number}.apply(...
%                    full_image_structure,current_cell,current_cell{object_number},texture,current_cell_texture);
%            end
%
%            full_image_textures{marker_number,cell_number,object_number}=texture;
%            current_cell_texture=squeeze(full_image_textures(:,cell_number,:));
%        end
%
%        composite=zeros(image_size);
%        weights=zeros(image_size);
%        for i=1:number_of_objects_per_cell
%            for j=1:number_of_objects_per_cell
%                if(islogical(full_image_structure{cell_number,j}))
%                    mask=full_image_structure{cell_number,j};
%                else
%                    mask=false(image_size);
%                    for k=1:length(full_image_structure{cell_number,j})
%                        mask(full_image_structure{cell_number,j}{k})=true;
%                    end
%                end
%                if((i~=j))
%                    temp=full_image_textures{marker_number,...
%                        cell_number,j};
%                    if(~any(full_image_textures{marker_number,...
%                            cell_number,j}<0))
%                        composite(mask)=composite(mask)+subpopulations{subpopulation_number}...
%                            .overlap_matrix(i,j)*temp(mask);
%                        if(~subpopulations{subpopulation_number}.cooperativity_matrix(i,j))
%                            weights(mask)=weights(mask)+subpopulations{subpopulation_number}...
%                                .overlap_matrix(i,j);
%                        else
%                            weights(mask)=weights(mask)+(subpopulations{subpopulation_number}...
%                                .overlap_matrix(i,j)+subpopulations{subpopulation_number}...
%                                .overlap_matrix(j,i))/4;
%                        end
%                    end
%                end
%            end
%        end
%        mask1=weights>0;
%        composite(mask1)=composite(mask1)./weights(mask1);
%
%        mask2=(complete_composite>0)&mask1;
%        complete_composite(mask1)=(0.85*composite(mask1)+0.15*complete_composite(mask1));
%
%    end
%
%    final_image(:,:,marker_number)=complete_composite;
%end
%toc;
%%h=fspecial('gaussian',3,2);
%%final_image=imfilter(final_image,h);
%
%image_to_show=zeros(image_size(1),image_size(2),3);
%for marker_num=1:number_of_markers
%    image_to_show(:,:,marker_color_order(marker_num))=final_image(:,:,marker_num);
%end
%
%
%
end
