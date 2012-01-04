classdef Subpopulation
    %Basic subpopulation definition class
    %Contains object as well as marker information
    
    properties
        objects
        markers
        overlap_Matrix
        cooperativity_Matrix
        placement
        marker_draw_order
        marker_dependancy_matrix
        object_dependancy_struct
        object_dependancy_matrix
        object_draw_order
    end
    properties (Dependant)
    end
    
    methods
        function obj=Subpopulation()
            obj.objects=dynamicprops;%Shape_list;
            obj.markers=dynamicprops;%Marker_list;
            
        end

        function obj=calculate_shape_draw_order(obj)
               shapes=properties(obj.objects); 
               obj.object_dependancy_matrix=false(length(shapes));
               for i=1:length(shapes)
               dependancies=obj.objects.(shapes{i}).prerendered_object_list();
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
        
        function delete_shape(obj,shape_name)
          delete(findprop(obj.objects,shape_name));
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

