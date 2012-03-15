function answer = isaFile( file )
%ISAFILE True iff file exists, false otherwise.

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: May 8, 2007
% Last Update: March 2, 2008
%
% Copyright (C) 2008 Center for Bioimage Informatics/Murphy Lab
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

if( nargin == 1 )
    if( ~isa( file, 'char' ) )
        answer = false;
    elseif( exist( file, 'file' ) && ~exist( file, 'dir' ) )
        %Note: The function exist( file, 'file' ) true for files and
        %folders
        answer = true;
    else
        answer = false;
    end
else
    error( 'SLML Toolbox: Wrong number of input arguments' );
end
end%isaFile