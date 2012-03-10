classdef Constant_marker_level_operation <SimuCell_Marker_Operation
    %Constant_marker_level_operation : Sets a constant marker level intensity
    %for all pixels in a cell. This level is sampled from a normal distribution
    % of specifiable mean and variation
    
    properties
        mean_level
        sd_level
        description='Constant Marker Level. This level is sampled from a Normal Distribution with Specified Mean and Standard Deviation';
    end
    
    methods
       
        %The constructor needs to have the definitions of all the Parameter variables
        %declared as properties. Initial pre-processing, that one does not wish
        %to repeat every time the shape is generated can also be performed
        %here, potentially using a listener to make sure that all the
        %Parameters have been set (see SLML_nucleus_model)
        function obj=Constant_marker_level_operation()
            obj.mean_level=Parameter('Mean Marker Level',0.5,SimuCell_Class_Type.number,...
                [0,1],'Mean Marker Level[0-low, 1-High]');
            obj.sd_level=Parameter('Marker Level Sigma',0.2,SimuCell_Class_Type.number,...
                [0,Inf],'Standard Deviation [0- all cells have same level, Inf- uniform sampling]');
        end
        
        
        
        % The Apply function applies a marker operation to the input marker intensity to produce the output marker intensity.
        % The marker instensities are array of the size of the output image. This function is called by the engine
        % and will always have the same parameters passed to it:
        % current_marker - The input intensity of the marker in the cell being
        % rendered. It is a matrix of the size of the final image, with each
        % element representing the intensity of the marker. 
        % current_shape_mask - A binary  mask of the same size as the final image marking the shape (nucleus, cytoplasm etc) currently being rendered.
        % other_cells_mask -  A binary  mask of the same size as the final image marked with 1s at every pixel occupied by one of the other cells, and 0 otherwise.
        % needed_shapes - a cell array containing the shapes required (as specified in the needed_shape_list). Each shape is described by binary mask of the same size as the final image and the masks are in the same order as specified in prerendered_object_list
        % needed_markers - a cell array containing the marker intensities required (as specified in the prerendered_marker_list). Each marker is described by an array of the same size as the final image and the arrays are in the same order as specified in prerendered_marker_list
        % It is up to the person writing a plugin which part of this
        % information they want to use.
        function result=Apply(obj,current_marker,current_shape_mask,other_cells_mask,needed_shapes,needed_markers)
            chosen_level=obj.mean_level.value+obj.sd_level.value*randn();
            current_marker(current_shape_mask)=max(0,min(1,chosen_level));
            result=current_marker;
        end
        
        % This function contains the list of markers on specified shape (within the cell being
        % rendered),   stored as a cell array, that is required to render the present marker using the
        % Apply function.  The cell elements are of type
        % Marker_Operation_Queue, and should be passed to the function by a user
        % through one of the Parameters.
        function pre_list=prerendered_marker_list(obj)
            pre_list=cell(0);
        end
        
        % This function contains the list of shapes (within the cell being
        % rendered), specified as a cell array, that is required to render the present shape using the
        % output_shape function.  The cell elements are of type
        % SimuCell_Object, and should be passed to the function by a user
        % through one of the Parameters.
        function pre_list=needed_shape_list(obj)
            pre_list=cell(0);
        end
       
    end
end
