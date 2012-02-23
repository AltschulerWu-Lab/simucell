classdef Parameter <hgsetget
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        type
        allowed_values
        description
        
    end
    properties(Access=private)
      value_private;
    end
   properties(Dependent)
     value
   end
   events
    Parameter_Set
   end
   
    methods
        function obj=Parameter(name,value,type,allowed_values,description)
            obj.name=name;
            obj.value=value;
            obj.type=type;
            if(exist('allowed_values','var'))
                obj.allowed_values=allowed_values;
            end
            if(exist('description','var'))
                obj.description=description;
            end
        end
        
        function value = get.value(obj)
            value = obj.value_private;
        end
        
        function set.value(obj,val)
            if(obj.type==SimuCell_Class_Type.number)
                if(val<obj.allowed_values(1)|| val>obj.allowed_values(2))
                    error('Value is outside allowed range');
                end
            end
            if(obj.type==SimuCell_Class_Type.file_name)
                if(~isa(obj.allowed_values,'function_handle'))
                    error('allowed_values not a function_handle');
                end
                if(~obj.allowed_values(val))
                    error('Not a valid file type');
                end
            end
            obj.value_private=val;
        end
    end
    
end

