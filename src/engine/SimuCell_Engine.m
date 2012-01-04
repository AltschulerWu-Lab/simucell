function [final_mask,object_structure,full_result]=SimuCell_Engine(SimuCell_Params)


number_of_subpopulations=length(SimuCell_Params.subpopulations);
for subpop=1:number_of_subpopulations
    SimuCell_Params.subpopulations{subpop}=...
        SimuCell_Params.subpopulations{subpop}.calculate_shape_draw_order;
    
end

SimuCell_Params.overlap.Construct_Overlap_Matrix(SimuCell_Params.subpopulations);


subpopulation_number_of_cell=zeros(SimuCell_Params.number_of_cells,1); %Stores the subpopulation number of each cell
object_structure=struct; % Stores the shape of every object in every cell. Indexed by cell number

%Generating cell-wise object shapes
current_image_mask=false(SimuCell_Params.simucell_image_size);

full_result=cell(length(SimuCell_Params.overlap.ordered_shape_list),1);

for cell_number=1:SimuCell_Params.number_of_cells
    current_cell=struct;
    subpopulation_number=discrete_prob(SimuCell_Params.population_fractions); %replace by function with specified weights
    subpopulation_number_of_cell(cell_number)=subpopulation_number;
    
    draw_order=(SimuCell_Params.subpopulations{subpopulation_number}.object_draw_order);
    number_of_objects=length(draw_order);
    
    overlap_acceptable=false;
    iteration_counter=0;
    while(~overlap_acceptable)
        overlap_acceptable=true;
        for object_number=1:number_of_objects
            prerendered_shapes_in_cell=cell(0);
            prerendered_shape_names=...
                SimuCell_Params.subpopulations{subpopulation_number}.object_dependancy_struct.(draw_order{object_number});
            for i=1:length(prerendered_shape_names)
                prerendered_shapes_in_cell{i}=current_cell.(prerendered_shape_names{i});
            end
            pos=SimuCell_Params.subpopulations{subpopulation_number}.placement.pick_positions(current_image_mask);
            shape=SimuCell_Params.subpopulations{subpopulation_number}.objects.(draw_order{object_number}) ...
                .make_shape([pos(1),pos(2)],current_image_mask,prerendered_shapes_in_cell);
            current_cell.(draw_order{object_number})=shape;
            obj_num=SimuCell_Params.overlap.shape_to_number_map{subpopulation_number}(draw_order{object_number});
            if(~Overlap_Check(full_result,shape,SimuCell_Params.overlap.overlap_matrix,obj_num))
                overlap_acceptable=false;
                %disp('Check failed');
            end
        end
        
        iteration_counter=iteration_counter+1;
        if(iteration_counter>100)
            
            error('Cannot fit in any more cells');
        end
    end
    shapes=fieldnames(current_cell);
    for i=1:length(shapes)
        current_image_mask=current_image_mask|current_cell.(shapes{i});
        object_structure(cell_number).(shapes{i})=sparse(current_cell.(shapes{i}));
        obj_num=SimuCell_Params.overlap.shape_to_number_map{subpopulation_number}(shapes{i});
        full_result{obj_num}=[full_result{obj_num} {sparse(current_cell.(shapes{i}))}];
    end
    
    
end
final_mask=current_image_mask;


for cell_number=1:SimuCell_Params.number_of_cells
    current_cell=struct;
    subpopulation_number=subpopulation_number_of_cell(cell_number);
    
    %draw_order=(SimuCell_Params.subpopulations{subpopulation_number}.marker_draw_order);
    number_of_markers=length(draw_order);
    %calculate mask from other cells
    
    for object=1:number_of_objects
        % marker draw order
        for marker_number=1:number_of_markers
            
            
            for operation_number=1:number_of_operations
                
            end
        end
    end
end


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
%            number_of_operations=length(subpopulations{subpopulation_number}.Markers{...
%                marker_number}.Operations{object_number});
%
%            for operation_number=1:number_of_operations
%                texture=subpopulations{subpopulation_number}.Markers{...
%                    marker_number}.Operations{object_number}{operation_number}.Apply(...
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
%                            .Overlap_Matrix(i,j)*temp(mask);
%                        if(~subpopulations{subpopulation_number}.Cooperativity_Matrix(i,j))
%                            weights(mask)=weights(mask)+subpopulations{subpopulation_number}...
%                                .Overlap_Matrix(i,j);
%                        else
%                            weights(mask)=weights(mask)+(subpopulations{subpopulation_number}...
%                                .Overlap_Matrix(i,j)+subpopulations{subpopulation_number}...
%                                .Overlap_Matrix(j,i))/4;
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
