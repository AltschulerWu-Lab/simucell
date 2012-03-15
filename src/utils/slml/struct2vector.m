function vector = struct2vector( snippet )
%STRUCT2VECTOR Parses a Matlab structure containing a vector in MathML into
%a Matlab array
% 
% Example 1
% ---------
% snippet = 
% 
%     cn: {[356.4586]  [11.7335]  [14.0128]  [28.4385]  [13.7484]  [11.4042]}
%     
% vector = struct2vector( snippet );

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: June 2, 2008
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

if ~isfield( snippet, 'cn' )
    error( 'SLML Toolbox: Either the vector is empty or it is not a numeric vector' );
else
    vector = cell2mat( snippet.cn );
end
end%struct2vector