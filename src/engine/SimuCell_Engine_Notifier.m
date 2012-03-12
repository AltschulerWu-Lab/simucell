classdef SimuCell_Engine_Notifier <handle
   
    properties
       message 
    end
    
    events
       warning ;
       error_thrown;
    end
end