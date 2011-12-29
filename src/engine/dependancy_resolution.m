function optimal_order=dependancy_resolution(dependancy_matrix)

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
%optimal_order=resolved;
end