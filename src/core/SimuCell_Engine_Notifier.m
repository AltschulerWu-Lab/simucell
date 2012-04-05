classdef SimuCell_Engine_Notifier <handle
  %SimuCell_Engine_Notifier class used to notify when warning or error
  %happend
  %
  %SimuCell_Engine_Notifier Properties:
  %   message - the message that would be display when the warning/error
  %   occur.
  %
  %USED IN THE ENGINE EXCLUSIVELY, RIGHT NOW TO CATH EVENT ON THE GUI
  %
  %
  %Copyright 2012 - S. Rajaram and B. Pavie for Altschuler and Wu Lab
  
  
  properties
    message
  end
  
  
  events
    warning ;
    error_thrown;
  end
  
  
end