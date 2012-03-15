function pts=ml_getlinept(s,t)
%ML_GETLINEPT Get coordinates of points on a line segment.
%   PTS = ML_GETLINEPT(S,T) returns the coordinates of points on a line
%   segment from S to T, which both are integer vectors with length 2.
%   PTS has two columns indicating X and Y coordinates.

%   ??-???-???? Initial write T. Zhao
%   Last Update: July 17, 2008 (icaoberg@cmu.edu)
%   Copyright (c) Murphy Lab, Carnegie Mellon University

% Copyright (C) 2007 Murphy Lab
% Carnegie Mellon University
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published
% by the Free Software Foundation; either version 2 of the License,
% or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
% 02110-1301, USA.
%
% For additional information visit http://murphylab.web.cmu.edu or
% send email to murphy@cmu.edu

if nargin < 2
    error('Exactly 2 arguments are required')
end

if any(round([s t])~=[s t])
    error('the points must be integers');
end

if s(1)==t(1)
    if s(2)<t(2)
        pts=[zeros(t(2)-s(2)+1,1)+s(1),(s(2):t(2))'];
    end
    if s(2)==t(2)
        pts=s;
    end
    if s(2)>t(2)
        pts=[zeros(s(2)-t(2)+1,1)+s(1),(s(2):-1:t(2))'];
    end
    return;
end

if s(2)==t(2)
    pts=ml_getlinept([s(2),s(1)],[t(2),t(1)]);
    pts=[pts(:,2),pts(:,1)];
end

if all(s<t)
    if isaLinux
        [pts,npts] = ml_getlinept_mex(s,t);
        pts = pts(:,1:npts)';
    else

        %old implementation
        dx=t(1)-s(1);
        dy=t(2)-s(2);

        if dy < 0
            dy = -dy;
            stepy = -1;
        else
            stepy = 1;
        end

        if (dx < 0)
            dx = -dx;
            stepx = -1;
        else
            stepx = 1;
        end

        dy=dy*2;
        dx=dx*2;

        pts(1,:)=s;

        if (dx > dy)
            fraction = dy - dx/2;
            while (s(1) ~= t(1))
                if fraction >= 0
                    s(2)=s(2)+stepy;
                    fraction=fraction-dx;
                end
                s(1)=s(1)+stepx;
                fraction=fraction+dy;
                pts=[pts;s];
            end
        else
            fraction= dx - dy/2;
            while (s(2) ~= t(2))
                if (fraction >= 0)
                    s(1)=s(1)+stepx;
                    fraction=fraction-dy;
                end
                s(2)=s(2)+stepy;
                fraction=fraction+dx;
                pts=[pts;s];
            end
        end
    end
end

if s(1)>t(1) & s(2)<t(2)
    pts=ml_getlinept([t(1)-s(1),s(2)],[0,t(2)]);
    pts(:,1)=t(1)-pts(:,1);
end

if all(s>t) |  (s(1)<t(1) & s(2)>t(2))
    pts=ml_getlinept(t,s);
    pts=flipud(pts);
end
end%ml_getlinept

