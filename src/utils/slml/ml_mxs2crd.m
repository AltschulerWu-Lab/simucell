function pts = ml_mxs2crd(medaxis,width)
%ML_MXS2CRD Convert medial axis shape to coordinates
%   PTS = ML_MXS2CRD(MEDAXIS,WIDTH) returns an array of points which are
%   represented by the medial axis shape with medial axsi MEDAXIS ans width
%   WIDTH.
%   
%   See also

%   30-Dec-2005 Initial write T. Zhao
%   Copyright (c) Center for Bioimage Informatics, CMU

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

if nargin < 2
    error('Exactly 2 arguments are required')
end

pts1(:,1) = medaxis(:,1);
pts1(:,2) = medaxis(:,2)-floor(width'/2); % **^*

pts2(:,1) = medaxis(:,1);
pts2(:,2) = medaxis(:,2)+floor(width'/2-0.5); % **^*

pts = [pts1;flipud(pts2)];
pts(end+1,:) = pts(1,:);
