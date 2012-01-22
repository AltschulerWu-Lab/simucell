classdef Subpopulation <handle
    %Basic subpopulation definition class
    %Contains object as well as marker information
    
    properties
        objects
        markers
        overlap_Matrix
        cooperativity_Matrix
        placement
        
        object_dependancy_struct
        object_dependancy_matrix
        object_draw_order
        
        
        marker_draw_order_objects
        marker_draw_order_names
        marker_dependancy_matrix
        
        compositing
        
        cell_artifacts
     
        
    end
    
    
    methods
        function obj=Subpopulation()
            obj.objects=dynamicprops;%Shape_list;
            obj.markers=dynamicprops;%Marker_list;
            
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
                draw_order=dependancy_resolution(obj.marker_dependancy_matrix);
                for i=1:length(draw_order)
                    obj.marker_draw_order_objects{i}=marker_shape_list{draw_order(i)};
                    obj.marker_draw_order_names{i}=marker_shape_list_names{draw_order(i)};
                end
            end
        end
        
        function add_object(obj,obj_name)
            obj.objects.addprop(obj_name);
            obj.objects.(obj_name)=SimuCell_Object();
        end
        
        function delete_shape(obj,shape_name)
            delete(findprop(obj.objects,shape_name));
        end
        
        function add_marker(obj,marker_name)
            obj.markers.addprop(marker_name);
            obj.markers.(marker_name)=Marker(obj.objects);
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
        
        function add_cell_artifact(obj,operation)
            if(isempty(obj.cell_artifacts))
                obj.cell_artifacts=cell(0);
            end
             obj.cell_artifacts{end+1}=operation;
%             marker_names=properties(obj.markers);
%             if(isempty(obj.cell_artifacts))
%                 obj.cell_artifacts=struct;
%                 
%                 for marker_num=1:length(marker_names)
%                     obj.cell_artifacts.(marker_names{marker_num})=cell(0);
%                 end
%             end
%             
%             for marker_num=1:length(marker_names)
%                 if(obj.markers.(marker_names{marker_num})==marker)
%                     obj.cell_artifacts.(marker_names{marker_num}){end+1}=operation;
%                     return;
%                 end
%             end
%             error('Marker Not Found in Subpopulation!');
            
        end
        
        %         function obj=AddObject(obj,object)
        %             obj.Objects{length(obj.Objects)+1}=object;
        %             obj.Overlap_Matrix=0.9*triu(ones(length(obj.Objects)))+...
        %                 0.1*tril(ones(length(obj.Objects)));
        %             %obj.Overlap_Matrix=ones(length(obj.Objects));
        %             obj.Cooperativity_Matrix=false(length(obj.Objects));
        %         end
        %         function obj=AddMarker(obj,marker)
        %             obj.Markers{length(obj.Markers)+1}=marker;
        %         end
        %         function obj=SetPlacement(obj,placement)
        %             obj.Placement=placement;
        %         end
        %
    end
    
end

