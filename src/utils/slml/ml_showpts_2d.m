function varargout=ml_showpts_2d(pts,option,periodic)
%ML_SHOWPTS_2D Plot points or lines.
%   ML_SHOWPTS_2D(PTS,OPTION,PERIODIC) plots 2D points in the 2-column
%   matrix PTS according to OPTION:
%       'pt' - points
%       'ln' - line segments
%       'cp' - cubic spline
%       'bp' - B spline
%   If OPTIONS is not 'pt' and PERIODIC is not 0, the last point and the 
%   first point will be connected.
%
%   PTS2 = ML_SHOWPTS_2D(PTS,OPTION,PERIODIC) returns the coordinates 
%   for plotting instead of plotting them.

%   16-Sep-2005 Initial write T. Zhao
%   Copyright (c) Murphy Lab, Carnegie Mellon University

% Copyright (C) 2007  Murphy Lab
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

if nargin < 3
    error('Exactly 3 arguments are required')
end

pts = double(pts);

npt=size(pts,1);
if periodic
    if npt>1
        pts=[pts;pts(1,:)];
        npt=npt+1;
    end
end

switch(option)
case 'pt'
    if nargout==1
        varargout{1}=pts;
    else
        plot(pts(:,1),pts(:,2),'x');
        axis('equal')
    end
case 'ln'
    if nargout==1
        if npt==1
            varargout{1}=pts;
        else
            pts=round(pts);
            varargout{1}=ml_getlinept(pts(1,:),pts(2,:));
            if npt>2
                for i=2:npt-1
                    lnpts=ml_getlinept(pts(i,:),pts(i+1,:));
                    if size(lnpts,1)>1
                        varargout{1}=[varargout{1};lnpts(2:end,:)];
                    end
                end
                
            end
        end
    else
        plot(pts(:,1),pts(:,2),'-');
        axis('equal')
    end
case 'cp'   %cubic spline
    sp=cscvn(pts');
    
    if nargout==1
        sppts=fnplt(sp);
        varargout{1}=ml_showpts_2d(round(sppts'),'ln',periodic);
    else
        fnplt(sp);
        axis('equal')
    end
case 'bp'   %b spline
    x=pts(:,1);
    y=pts(:,2);
    
    s = linspace(0,3,length(x)*3);
    ss=0:0.01:s(length(x));
    spx=spapi(4,s,repmat(x',1,3));
    spy=spapi(4,s,repmat(y',1,3));
    
    xx=spval(spx,ss);
    yy=spval(spy,ss);
    
    if nargout==1
        varargout{1}=tz_showpts_2d(round([xx;yy]'),'ln',periodic);
    else
        %         plot(xx,yy)
        ml_showpts_2d(round([xx;yy]'),'ln',periodic);
        axis('equal')
    end
end
