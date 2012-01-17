%TODO: Add more colors
%Enum the list of color: enumeration Colors
%get the number of Colors:
% mc = ?Colors;
% length(mc.EnumeratedValues);
%Get first color:
%mc.EnumeratedValues{1}.Name
%Get the rgb color value:
%redColor=Colors.Red;
%color=[redColor.R redColor.B redColor.G];

classdef Colors
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