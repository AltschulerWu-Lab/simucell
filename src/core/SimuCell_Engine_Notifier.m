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
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.SimuCell.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%
  
  
  properties
    message
  end
  
  
  events
    warning ;
    error_thrown;
  end
  
  
end
