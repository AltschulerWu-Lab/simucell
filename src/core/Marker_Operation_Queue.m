classdef Marker_Operation_Queue <handle
  %Marker_Operation_Queue class used to store operations affecting Marker.
  %This class is used internally.
  %
  %Marker_Operation_Queue Properties:
  %   operations - the color used to display the marker
  %     value   : a Color value (e.g., 'Red'), see available value in class
  %     Colors.
  %
  % Overlap_Specification Methods:
  %   AddOperation - Add a marker operation
  %     -operation: the operation which will be add to the object marker
  %     queue of operations
  %   DeleteOperation - remove a marker operation
  %     -operation: the operation which will be add to the object marker
  %     queue of operations
  %   CloneOperationQueue - clone the object marker operation queue
  %
  %Usage:
  %%Define a new Marker operation
  %op=Constant_Marker_Level();
  %set(op,'mean_level',0.7);
  %set(op,'sd_level',0.1);
  %
  %%Add this operation to your marker for the predefined shape cytoplasm
  %subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
  %
  %%Delete an operation
  %subpop{1}.markers.Actin.cytoplasm.DeleteOperation(op);
  %
  %%Clone an operation
  %operation_queue=subpop{1}.markers.Actin.cytoplasm.CloneOperationQueue();
  %
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties (SetAccess=private)
    operations
  end
  
  
  methods
    
    function obj=Marker_Operation_Queue()
      obj.operations=cell(0);
    end
    
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

