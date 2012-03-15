function answer = hasTag( data, tag, option )
%HASTAG True if data contains the tag, false otherwise.

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: May 29, 2007
% Last Update: March 8, 2008
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

if( nargin ~= 3 )
    error( 'SLML Toolbox: Wrong number of input arguments' );
else
    answer = false;
    if( isaFile( data ) )
        data = textread( data,'%s','delimiter','\n');
    end

    if( strcmpi( option, 'start' ) )
        for i=1:1:length( data )
            if strfind( data{i}, ['<' tag] )
                answer = true;
            end
        end
    elseif( strcmpi( option, 'end' ) )
        for i=1:1:length( data )
            if strfind( data{i}, ['</' tag] )
                answer = true;
            end
        end
    else
        error( ['SLML Toolbox: Option ' option ' not valid.'] )
    end
end
end%hasTag