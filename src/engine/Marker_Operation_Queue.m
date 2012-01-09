classdef Marker_Operation_Queue <handle
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
        function AddOperation(obj,operation)
            obj.operations{end+1}=operation;
        end
        
        function DeleteOperation(obj,operation)
            if(isnumeric(operation))
                if(operation>=1 && operation<= length(obj.operations))
                    obj.operations(operation)=[];
                end
            end
        end
        
        function obj1=CloneOperationQueue(obj)
            obj1=Marker_Operation_Queue();
            number_of_operations=length(obj.operations);
            for op_num=1:number_of_operations
               op_temp=eval(class(obj.operations{op_num}));
               params=properties(obj.operations{op_num});
               for i=1:length(params)
                  if(isa(op_temp.(params{i}),'Parameter')) 
                    op_temp.(params{i}).value=obj.operations{op_num}.(params{i}).value; 
                  end
               end
               obj1.AddOperation(op_temp);
            end
           
            
            
        end
        
    end
    
end

