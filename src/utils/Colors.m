%TODO: Add more colors
%Enum the list of color: enumeration Colors
%Get the rgb color value:
%redColor=Colors.red;
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
    Red   (1, 0, 0)
    Green (0, 1, 0)
    Blue  (0, 0, 1)
  end
end