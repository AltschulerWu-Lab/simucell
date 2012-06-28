classdef Colors
%Colors generic used to stored default color enumeration
%
%Colors Properties:
%   R - red value in RGB 
%     Range value   : 0 to 1
%   G - green value in RGB 
%     Range value   : 0 to 1
%   B - blue value in RGB 
%     Range value   : 0 to 1
%
%Usage:
%%Enum the list of color: 
%enumeration Colors
%
%%get the number of Colors:
%mc = ?Colors;
%length(mc.EnumeratedValues);
%
%%Get first color:
%mc.EnumeratedValues{1}.Name
%
%%Get the rgb color value:
%redColor=Colors.Red;
%color=[redColor.R redColor.B redColor.G];
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
    R = 0;
    G = 0;
    B = 0;
  end
  
  
  methods
    
    function c = Colors(r, g, b)
      c.R = r; c.G = g; c.B = b;
    end
    
  end
  
  
  enumeration
    Red     (1,   0,  0)
    Green   (0,   1,  0)
    Blue    (0,   0,  1)
    Cyan    (0,   1,  1)
    Magenta (1,   0,  1)
    Yellow  (1,   1,  0)
    Orange  (1,  .5,  0)
    Gray    (.5, .5, .5)
  end
  
  
end
