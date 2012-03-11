classdef Subpopulation <handle
    %SUBPOPULATION   Properties of cells in a  specific sub-population (cell-types) are described
    %by this class. It is the primary class that needs to be defined by the
    %user.
    %Subpopulation properties:
    %   objects     - a class of type dynamicprops that defines the
    %   different objects (nucleus, cytoplams).
    %   markers     - a class of type dynamicprops that defines thes the
    %   different markers.
    %   placement   - the chosen placement model (plugin) to place the
    %   various objects.
    %   compositing - the chosen scheme to combine marker levels on overlapping objects.
    %   cell_artifacts - a cell containing a list of operations (plugins
    %   classes derived from SimuCell_CellArtifact_Operation), used to
    %   apply artifacts on a cell by cell basis e.g. Focal Plane Effects
    %Subpopulation methods:
    %   Subpopulation   - Create a new Subpopulation 
    %   add_object      - Add a new object (nucleus, cytoplasm) to the subpopulation
    %   add_marker      - Add a new marker to the subpopulation
    %   add_cell_artifact       - Add a new  cell level artifact operation to
    %   the subpopulation
    %   See also  SimuCell_Model,
    %   Constant_dependant_marker_level_operation,Perlin_texture
    %
    %
    %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
    properties
        objects
        markers
        placement
        compositing
        cell_artifacts
        
    end
    
    
    
    methods
        function obj=Subpopulation() 
        %Subpopulation   - Create a new Subpopulation 
        %
        %
            obj.objects=dynamicprops;%Shape_list;
            obj.markers=dynamicprops;%Marker_list;
            
        end
        
        function add_object(obj,obj_name)
        %   add_object      - Add a new object (nucleus, cytoplasm) to the subpopulation
        %
        %   add_object(subpop,obj_name) creates a new property of name obj_name (which
        %   is assumed to be a string) and type SimuCell_Object in the objects property of the subpopulation specified by subpop.
        %
        %   See also  Subpopulation,SimuCell_Object
        %
        %   Examples:
        %   subpop=Subpopulation();
        %   add_object(subpop,'cytoplasm');
        %   subpop.objects.cytoplasm.model=Elliptical_nucleus_model;
        %   set(subpop.objects.cytoplasm.model,'radius',40);
        %
        %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
            obj.objects.addprop(obj_name);
            obj.objects.(obj_name)=SimuCell_Object();
            %TODO
            %Get Marker list and add this new object if not exist to all
            %this marker
        end
        
        function add_marker(obj,marker_name,marker_color)
        %   add_marker      - Add a new marker to the subpopulation
        %
        %   add_marker(subpop, marker_name,marker_color) creates a new property of name marker_name (a string), 
        %   type Marker and color specified by marker_color (one of the colors enumerated in Colors) in the markers property in the Subpopulation subpop
        %   
        %   
        %   add_marker(subpop, marker_name,marker_color) creates a new property of name marker_name (a string), 
        %   type Marker which is Red in color in the markers property in the Subpopulation subpop
        %   
        %   See also  Subpopulation,SimuCell_Object,Marker
        %
        %   Examples: 
        %   subpop=Subpopulation();
        %   add_object(subpop,'cytoplasm');
        %   subpop.objects.cytoplasm.model=Elliptical_nucleus_model;
        %   add_marker(subpop,'DAPI','Blue');
        %   op=Constant_marker_level_operation();
        %   set(op,'mean_level',0.1);
        %   set(op,'sd_level',0.1);
        %   subpop.markers.DAPI.cytoplasm.AddOperation(op);
        %
        %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
            obj.markers.addprop(marker_name);
            if(nargin>2)
                obj.markers.(marker_name)=Marker(obj.objects,marker_color);
            else
                obj.markers.(marker_name)=Marker(obj.objects);
            end
        end
        
        function add_cell_artifact(obj,operation)
        %   add_cell_artifact      - Add a new  cell level artifact operation to
        %   the subpopulation
        %
        %   add_cell_artifact(subpop, operation) adds the cell artifact defined
        %   by operation to the queue of SimuCell_CellArtifact_Operation-s to
        %   be performed on cells in Subpopulation subpop. 
        %   
        %   See also  Subpopulation,SimuCell_CellArtifact_Operation
        %
        %   Examples: 
        %   subpop=Subpopulation();
        %   add_object(subpop,'cytoplasm');
        %   add_marker(subpop,'DAPI','Blue');
        %   op=Constant_marker_level_operation();
        %   set(op,'mean_level',0.1);
        %   set(op,'sd_level',0.1);
        %   subpop.markers.DAPI.cytoplasm.AddOperation(op);
        %   op=Out_Of_Focus_Cells();
        %   set(op,'fraction_blurred',0.04);
        %   set(op,'blur_radius',4);
        %   add_cell_artifact(subpop,op); 
        %
        %   Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
            if(isempty(obj.cell_artifacts))
                obj.cell_artifacts=cell(0);
            end
            obj.cell_artifacts{end+1}=operation;
            
        end
    end
    
     properties (Hidden,SetAccess=private)
        
        object_dependancy_struct
        object_dependancy_matrix
        object_draw_order
        
        
        marker_draw_order_objects
        marker_draw_order_names
        marker_dependancy_matrix
        
        full_dependancy_matrix
        full_names
        
    end
    
    
    methods (Hidden)
        
        
        
        function [obvious_deletions,all_deletions]=calculate_all_dependancies(obj,to_be_deleted)
            shape_names=properties(obj.objects);
            marker_names=properties(obj.markers);
            
            obj.full_dependancy_matrix=false(length(shape_names)*(1+length(marker_names)));
            obj.full_names=cell(length(shape_names)*(1+length(marker_names)),1);
            %shapexshape part of the matrix is the same as the
            %object_dependancy_matrix calculation
            for i=1:length(shape_names)
                if(isempty(obj.objects.(shape_names{i}).model))
                  dependancies=cell(0);
                else
                  dependancies=obj.objects.(shape_names{i}).model.prerendered_object_list();
                end
                obj.object_dependancy_struct.(shape_names{i})=cell(0);
                for k=1:length(dependancies)
                    for j=1:length(shape_names)
                        if(obj.objects.(shape_names{j})==dependancies{k})
                            obj.object_dependancy_struct.(shape_names{i}){k}=shape_names{j};
                        end
                    end
                end
                for j=1:length(shape_names)
                    obj.full_dependancy_matrix(i,j)=...
                        any(cellfun(@(x) x==obj.objects.(shape_names{j}),dependancies));
                end
                obj.full_names{i}=shape_names{i};
            end
            
            
            %Calculate list of all marker-shape pairs for given
            %subpopulation. Each will be a list of operations
            marker_shape_list=cell(length(marker_names)*length(shape_names),1);
            marker_shape_list_names=cell(length(marker_names)*length(shape_names),1);
            obj_counter=1;
            for marker_counter=1:length(marker_names)
                for shape_counter=1:length(shape_names)
                    marker_shape_list{obj_counter}=...
                        obj.markers.(marker_names{marker_counter})...
                        .(shape_names{shape_counter});
                    marker_shape_list_names{obj_counter}=...
                        {marker_names{marker_counter},shape_names{shape_counter}};
                    obj.full_dependancy_matrix(obj_counter+length(shape_names),shape_counter)=true;
                    obj.full_names{obj_counter+length(shape_names)}=...
                        [marker_names{marker_counter} '>' shape_names{shape_counter}];
                    obj_counter=obj_counter+1;
                end
            end
            
            
            
            
            %Calculate dependancy of marker on shapes
            for marker_shape_counter=1:length(marker_shape_list)
                
                operations=marker_shape_list{marker_shape_counter}.operations;
                
                for operation_counter=1:length(operations)
                    
                    dependancies=operations{operation_counter}.needed_shape_list;
                    
                    for j=1:length(shape_names)
                        if(any(cellfun(@(x) x==obj.objects.(shape_names{j}),dependancies)))
                            obj.full_dependancy_matrix(length(shape_names)+marker_shape_counter,j)=true;
                        end
                        
                        
                    end
                end
                
            end
            
            %Calculate dependency of marker on marker
            for marker_shape_counter=1:length(marker_shape_list)
                
                operations=marker_shape_list{marker_shape_counter}.operations;
                
                for operation_counter=1:length(operations)
                    
                    dependancies=operations{operation_counter}.prerendered_marker_list;
                    
                    for j=1:length(marker_shape_list)
                        
                        if(any(cellfun(@(x) x==marker_shape_list{j},dependancies)))
                            obj.full_dependancy_matrix(marker_shape_counter+length(shape_names),j+length(shape_names))=true;
                            
                        end
                        
                    end
                end
                
            end
            deleted_number=[];
            
            
            if(isa(to_be_deleted,'SimuCell_Object'))
                obvious_deletions=cell(length(marker_names)+1,1);
                for i=1:length(shape_names)
                    if(obj.objects.(shape_names{i})==to_be_deleted)
                        deleted_number=i;
                        obvious_deletions{1}=shape_names{i};
                        for j=1:length(marker_names)
                            obvious_deletions{j+1}=...
                                [marker_names{j} '>' shape_names{i}];
                        end
                    end
                end
            end
            if(isa(to_be_deleted,'Marker_Operation_Queue'))
                obvious_deletions=cell(1);
                for i=1:length(marker_shape_list)
                    if(marker_shape_list{i}==to_be_deleted)
                        deleted_number=i+length(shape_names);
                        obvious_deletions{1}=marker_shape_list_names{i};
                    end
                end
            end
            
            if(isa(to_be_deleted,'Marker'))
                temp_names=properties(to_be_deleted);
                obvious_deletions=cell(length(shape_names),1);
                counter=1;
                for j=1:length(temp_names)
                    if(isa(to_be_deleted.(temp_names{j}),'Marker_Operation_Queue'))
                        
                        
                        for i=1:length(marker_shape_list)
                            if(marker_shape_list{i}==to_be_deleted.(temp_names{j}))
                                deleted_number=[deleted_number;i+length(shape_names)];
                                obvious_deletions{counter}=...
                                    [marker_shape_list_names{i}{1} '>' marker_shape_list_names{i}{2}];
                                counter=counter+1;
                            end
                        end
                    end
                end
            end
            
            dependant_objects=[];
            for j=1:length(deleted_number)
                dependant_objects=union(dependant_objects, ...
                    graphtraverse(sparse(obj.full_dependancy_matrix)',...
                    deleted_number(j)));
            end
            all_deletions=cell(length(dependant_objects),1);
            for i=1:length(dependant_objects)
                if(dependant_objects(i)<=length(shape_names))
                    %disp(shape_names{dependant_objects(i)})
                    all_deletions{i}=shape_names{dependant_objects(i)};
                else
                    ms_num=dependant_objects(i)-length(shape_names);
                    all_deletions{i}=[marker_shape_list_names{ms_num}{1}...
                        '>' marker_shape_list_names{ms_num}{2}];
                    %disp([marker_shape_list_names{ms_num}{1} '>' marker_shape_list_names{ms_num}{2}]);
                end
            end
            
        end
        
        function calculate_shape_draw_order(obj)
            shapes=properties(obj.objects);
            obj.object_dependancy_matrix=false(length(shapes));
            for i=1:length(shapes)
                dependancies=obj.objects.(shapes{i}).model.prerendered_object_list();
                obj.object_dependancy_struct.(shapes{i})=cell(0);
                for k=1:length(dependancies)
                    for j=1:length(shapes)
                        if(obj.objects.(shapes{j})==dependancies{k})
                            obj.object_dependancy_struct.(shapes{i}){k}=shapes{j};
                        end
                    end
                end
                for j=1:length(shapes)
                    obj.object_dependancy_matrix(i,j)=...
                        any(cellfun(@(x) x==obj.objects.(shapes{j}),dependancies));
                end
                
            end
            draw_order=dependancy_resolution(obj.object_dependancy_matrix);
            for i=1:length(draw_order)
                obj.object_draw_order{i}=shapes{draw_order(i)};
            end
        end
        
        
        function calculate_marker_draw_order(obj)
            
            shape_names=properties(obj.objects);
            marker_names=properties(obj.markers);
            
            %Calculate list of all marker-shape pairs for given
            %subpopulation. Each will be a list of operations
            marker_shape_list=cell(length(marker_names)*length(shape_names),1);
            marker_shape_list_names=cell(length(marker_names)*length(shape_names),1);
            obj_counter=1;
            for marker_counter=1:length(marker_names)
                for shape_counter=1:length(shape_names)
                    marker_shape_list{obj_counter}=...
                        obj.markers.(marker_names{marker_counter})...
                        .(shape_names{shape_counter});
                    marker_shape_list_names{obj_counter}=...
                        {marker_names{marker_counter},shape_names{shape_counter}};
                    obj_counter=obj_counter+1;
                end
            end
            
            
            
            obj.marker_dependancy_matrix=false(length(marker_shape_list));
            
            for marker_shape_counter=1:length(marker_shape_list)
                
                operations=marker_shape_list{marker_shape_counter}.operations;
                
                for operation_counter=1:length(operations)
                    
                    dependancies=operations{operation_counter}.prerendered_marker_list;
                    
                    for j=1:length(marker_shape_list)
                        
                        if(any(cellfun(@(x) x==marker_shape_list{j},dependancies)))
                            obj.marker_dependancy_matrix(marker_shape_counter,j)=true;
                            
                        end
                        
                    end
                end
                %                 draw_order=dependancy_resolution(obj.marker_dependancy_matrix);
                %                 for i=1:length(draw_order)
                %                     obj.marker_draw_order_objects{i}=marker_shape_list{draw_order(i)};
                %                     obj.marker_draw_order_names{i}=marker_shape_list_names{draw_order(i)};
                %                 end
            end
            draw_order=dependancy_resolution(obj.marker_dependancy_matrix);
            for i=1:length(draw_order)
                obj.marker_draw_order_objects{i}=marker_shape_list{draw_order(i)};
                obj.marker_draw_order_names{i}=marker_shape_list_names{draw_order(i)};
            end
        end
        
        
        
        function delete_shape(obj,shape_name)
            delete(findprop(obj.objects,shape_name));
            marker_names=properties(obj.markers);
            for i=1:length(marker_names)
                delete(findprop(obj.markers.(marker_names{i}),shape_name));
            end
        end
        
        
        
        function delete_marker(obj,marker_name)
            delete(findprop(obj.markers,marker_name));
        end
        
        function name=find_shape_name(obj,shape_object)
            name=[];
            name_list=properties(obj.objects);
            for i=1:length(name_list)
                if(obj.objects.(name_list{i})==shape_object)
                    name=name_list{i};
                    return;
                end
            end
        end
        
        
        function [marker_name,shape_name]=find_marker_name(obj,marker_object)
            shape_names=properties(obj.objects);
            marker_names=properties(obj.markers);
            
            marker_name=[];
            shape_name=[];
            for marker_counter=1:length(marker_names)
                for shape_counter=1:length(shape_names)
                    if(marker_object==...
                            obj.markers.(marker_names{marker_counter})...
                            .(shape_names{shape_counter}))
                        marker_name=marker_names{marker_counter};
                        shape_name=shape_names{shape_counter};
                        return;
                    end
                    
                end
            end
            
            if(isempty(marker_name)||isempty(shape_name))
                error('object passed to find_marker_name does not exist');
            end
        end
        
        
        
        
    end
    
end

