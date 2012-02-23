classdef SimuCell_Model <hgsetget
    % Template abstract class for all simucell objects, so everything can
    % be be derived from this class
    
    properties (Abstract)
        description
    end
    
    methods (Abstract)
       %obj=set_default_parameters(obj);
     
    end
    
    methods 
         function obj= set(obj,varargin)  
                p = inputParser;
                props=properties(obj);
                for i=1:length(props)
                 if(isa(obj.(props{i}),'Parameter'))
                    p.addParamValue(props{i},obj.(props{i}).value);
                 else
                    p.addParamValue(props{i},obj.(props{i})); 
                 end
                    
                end
                p.parse(varargin{:});
                chosen_fields=fieldnames(p.Results);
                for i=1:length(chosen_fields)
                    if(isa(obj.(chosen_fields{i}),'Parameter'))
                        obj.(chosen_fields{i}).value=p.Results.(chosen_fields{i});
                        
                    else
                        obj.(chosen_fields{i})=p.Results.(chosen_fields{i});
                    end
                end
                for i=1:length(chosen_fields)
                    if(isa(obj.(chosen_fields{i}),'Parameter'))
                        
                        notify(obj.(chosen_fields{i}),'Parameter_Set');
                    end
                end
         end
    end
    
 
  
end

