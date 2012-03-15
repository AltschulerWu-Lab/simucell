function slml2img( varargin )
% SLML2IMG Synthesizes a set of multicolor digital images from a collection
% of SLML Level 1.0 Version 1.* instances.
%
% COMMENT: The minimum number of input arguments is four. The maximum is
% unbounded. Read the documentation for further information.
%
% Input arguments           Descriptions
% ---------------           ------------
% file{s}                   Filenames of the different SLML files or .mat files 
%                           which contain a variable called model
% targetDirectory           Directory where the images are going to be saved
% prefix                    Filename prefix for the synthesized images
% numberOfSynthesizedImages Number of synthesized images
% compression               Compression of tiff, i.e. 'none', 'lzw' and 'packbits'
%
% Examples
% --------
% >> slml2img( 'model01.xml', pwd, 'experiment', 5, 'packbits' );
% >> slml2img( 'model01.xml', 'model02.xml', 'model03.xml', '~/data', ...
%     'experiment', 5, 'none' );

% Author: Ivan E. Cao-Berg (icaoberg@cmu.edu)
% Created: May 8, 2007
% Last Update: August 4, 2008
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

if( nargin < 5 )%check number of input arguments
    error('SLML Toolbox: Wrong number of input arguments');
else%check if files exists and are valid SLML instances
    for i=1:length(varargin)-4
        if ~isaFile( varargin{i} ) 
            error( ['SLML Toolbox: Input argument ' i ' is not a file'] );
        end
    end

    %parse SLML instances into Matlab structures
    models = struct([]);
    if nargin == 5
	if( isMatFile(varargin{1}) )
		load(varargin{1});
		models = model;
	else
	        models = slml2model( varargin{1} );
	end
    else
        for i=1:1:length(varargin)-4
		if( isMatFile(varargin{i}) )
			load(varargin{i});
			models{i} = model;
		else
            		models{i} = slml2model(varargin{i});
		end
        end
    end

    %get parameters for the model2img function
    targetDirectory = varargin{length(varargin)-3};
    prefix = varargin{length(varargin)-2};
    if isdeployed
        numberOfSynthesizedImages = str2double( varargin{length(varargin)-1} );
    else
        numberOfSynthesizedImages = varargin{length(varargin)-1};
    end
    compression = varargin{length(varargin)};
        

    %synthesize multicolor images and save them to disk
    for i=1:1:numberOfSynthesizedImages
        image = model2img( models );
        img2tif( image, [ targetDirectory '/' prefix num2str(i) '.tif'], compression );
    end
end
end%slml2img
