function fileExtension = getFileExtension( filename )
%GETFILEEXTENSION If the file exists, then the function will return only
%the file extension.
%
%Example
%> fileExtension = getFileName( 'model.xml' )
%  fileExtension =
%
%  xml

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: May 8, 2007
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

if( nargin ~= 1 )
    error( 'SLML Toolbox: Wrong number of input arguments' );
elseif( nargin == 1 )
    if( ~exist( filename, 'file' ) )
        error( ['SLML Toolbox: The file ' filename ' does not exist.'] );
    else
        dot = findstr( filename, '.' );
        fileExtension = filename( dot(end)+1:end );
    end
end
end%getFileExtension