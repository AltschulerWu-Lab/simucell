classdef Marker_Operation_Queue
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        operations
       
    end
    
    methods
        function obj=Marker_Operation_Queue()
%             obj.Operations=cell(number_of_objects,1);
%             for i=1:number_of_objects
%                 obj.Operations{i}=cell(0);
%             end
              obj.operations=cell(0);
        end
%         function obj=Marker(density_model,texture_model)
%             obj.Density=density_model;
%             obj.Texture=texture_model;
%         end
        function obj=AddOperation(obj,operation)
            obj.operations{end+1}=operation;
        end
      
        
    end
    
end

