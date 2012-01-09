classdef Overlap_Specification <handle
    properties
        overlap_lists
        overlap_values
        ordered_shape_list
        shape_to_number_map
        overlap_matrix
    end
    
    methods
        function obj=Overlap_Specification()
            obj.overlap_lists=cell(0);
            obj.overlap_values=[];
        end
        function AddOverlap(obj,object_list,overlap_value)
            obj.overlap_values=[obj.overlap_values(:) overlap_value];
            obj.overlap_lists=[obj.overlap_lists {object_list}];
        end
        
        
        function construct_overlap_matrix(obj,subpopulations)
            obj.ordered_shape_list=cell(0);
            obj.shape_to_number_map=cell(0);
            number_of_subpopulations=length(subpopulations);
            shape_counter=0;
            for subpop=1:number_of_subpopulations
                shapes= properties(subpopulations{subpop}.objects);
                obj.shape_to_number_map{subpop}=containers.Map;
                for i=1:length(shapes)
                    shape_counter=shape_counter+1;
                    obj.ordered_shape_list=[obj.ordered_shape_list,{subpopulations{subpop}.objects.(shapes{i})}];
                    obj.shape_to_number_map{subpop}(shapes{i})=shape_counter;
                end
            end
            obj.overlap_matrix=ones(length(obj.ordered_shape_list));
            for list_counter=1:length(obj.overlap_lists)
                temp_list=obj.overlap_lists{list_counter};
                for i=1:length(temp_list)
                   for j=1:i
                 
                       n1=find(cellfun(@(x) x==temp_list{i},obj.ordered_shape_list),1);
                       n2=find(cellfun(@(x) x==temp_list{j},obj.ordered_shape_list),1);
                       obj.overlap_matrix(n1,n2)=obj.overlap_values(list_counter);
                       obj.overlap_matrix(n2,n1)=obj.overlap_values(list_counter);
                       
                   end
                end
            end
            
        end
        
        
    end
end