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
            p.KeepUnmatched = true;
            %                props=properties(obj);
            %                 for i=1:length(props)
            %                  if(isa(obj.(props{i}),'Parameter'))
            %                     %p.addParamValue(props{i},obj.(props{i}).value);
            %                   % p.addOptional(props{i});
            %                  else
            %                     %p.addParamValue(props{i},obj.(props{i}));
            %                  end
            %
            %                 end
            p.parse(varargin{:});
            chosen_fields=fieldnames(p.Unmatched);
            
            for i=1:length(chosen_fields)
              %Following works only from Matlab version 2011a, not before
              %if(isprop(obj,chosen_fields{i}))
              %So replaced by:
              if ~isempty(strcmp(chosen_fields{i}, properties(obj)))
                if(isa(obj.(chosen_fields{i}),'Parameter'))
                  obj.(chosen_fields{i}).value=p.Unmatched.(chosen_fields{i});
                else
                  obj.(chosen_fields{i})=p.Unmatched.(chosen_fields{i});
                end
              else
                error([chosen_fields{i} ' is not a valid property']);
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

