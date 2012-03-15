function answer = isSlmlInstanceValid( slmlInstance )
%ISSLMLINSTANCEVALID True if the argument is a valid SLML instance, false
%otherwise.

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

if( nargin ~= 1 )
    error( 'SLML Toolbox: Wrong number of input arguments.' );
elseif( isaFile( slmlInstance ) )
    data = textread( slmlInstance,'%s','delimiter','\n');

    if( ~hasTag( data, 'slml', 'start' ) || ~hasTag( data, 'slml', 'end' ) )
        answer = false;
    elseif( ~hasTag( data, 'cell', 'start' ) || ~hasTag( data, 'cell', 'end' ) )
        answer = false;
    elseif( ~hasTag( data, 'model', 'start' ) || ~hasTag( data, 'model', 'end' ) )
        answer = false;
    elseif( ~hasTag( data, 'listOfCompartments', 'start' ) || ...
            ~hasTag( data, 'listOfCompartments', 'end' ) )
        answer = false;
    elseif( isempty( getNuclearModelDelimiters( data ) ) )
        answer = false;
    elseif( isempty( getCellMembraneModelDelimiters( data ) ) )
        answer = false;
    elseif( isempty( getProteinModelDelimiters( data ) ) )
        answer = false;
    else
        answer = true;
    end
elseif( isa( slmlInstance, 'cell' ) )
    data = slmlInstance;

    if( ~hasTag( data, 'slml', 'start' ) || ~hasTag( data, 'slml', 'end' ) )
        answer = false;
    elseif( ~hasTag( data, 'cell', 'start' ) || ~hasTag( data, 'cell', 'end' ) )
        answer = false;
    elseif( ~hasTag( data, 'model', 'start' ) || ~hasTag( data, 'model', 'end' ) )
        answer = false;
    elseif( ~hasTag( data, 'listOfCompartments', 'start' ) || ...
            ~hasTag( data, 'listOfCompartments', 'end' ) )
        answer = false;
    elseif( isempty( getNuclearModelDelimiters( data ) ) )
        answer = false;
    elseif( isempty( getCellMembraneModelDelimiters( data ) ) )
        answer = false;
    elseif( isempty( getProteinModelDelimiters( data ) ) )
        answer = false;
    else
        answer = true;
    end
else
    error( 'SLML Toolbox: Input argument must be an XML file or cell array.' );
end

end%isSlmlInstanceValid