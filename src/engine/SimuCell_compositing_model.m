classdef SimuCell_compositing_model<SimuCell_Model
    
    
    methods (Abstract)
        object_compositing_matrix=calculate_compositing_matrix(cell);
        %obj_list=object_list(numeric);
    end
    
end