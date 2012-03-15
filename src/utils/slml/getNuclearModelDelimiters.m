function delimiters = getNuclearModelDelimiters( data )
%GETNUCLEARMODELDELIMITERS Helper function that returns the two compartment
%delimiter indexes of the nuclear model.

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

delimiters = [];
for i=1:1:length( data )
    if strfind( data{i}, '<compartment name="nucleus"' )
        delimiters = i;
    end
end

for i=delimiters:1:length( data )
    if strfind( data{i}, '</compartment>' )
        delimiters = [delimiters i];
    elseif length( delimiters ) > 1
        break;
    end
end
end%getNuclearModelDelimiters