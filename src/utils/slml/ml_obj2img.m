function [img,posoffset] = ml_obj2img(obj,imgsize,mode)
%ML_OBJ2IMG Convert an object to an image.
%   IMG = ML_OBJ2IMG(OBJ,IMGSIZE) returns an image with the object
%   OBJ in it. The object will at its original position unless IMGSIZE
%   is empty, which means the image size will be the smallest rectangle
%   enclosing OBJ and OBJ will be at the center of the image. Practically,
%   the image will be extended with one pixel for the four borders.
%   ML_OBJ2IMG(OBJ,IMGSIZE,{}) returns the same thing.
%
%   IMG = ML_OBJ2IMG(OBJ,IMGSIZE,{MODE1,MODE2}) also spedify the
%   mode of image synthesis. See ML_OBJS2IMG for details about MODE1 and
%   MODE2.
%
%   IMG = ML_OBJ2IMG(OBJ,IMGSIZE,{MODE1,MODE2,MODE3}) supports another
%   mode MODE3. If MODE3 is 'ct', the object will be located at the
%   center of the image.
%
%   [IMG,POSOFFSET] = ML_OBJ2IMG(..) returns the offset between the original 
%   position of OBJ and its position in IMG, i.e. 
%   image position = original position + POSOFFSET

%   27-JUN-2004 Initial write T. Zhao
%   05-NOV-2004 Modified T. Zhao
%       - change function name tz_objimg --> tz_obj2img
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

if nargin < 2
    error('2 or 3 arguments are required')
end

if isempty(obj)
    img=[];
    return
end

if ~exist('mode','var')
    mode = {};
end

if isempty(mode)
    mode{1}='2d';
    mode{2}='og';
end

posoffset = [];

switch(mode{1})
case '2d'
    if size(obj,2)>2
        objpos=obj(:,1:2);
        gray=obj(:,3);
    else
        objpos=obj;
        gray=[];
    end
case '3d'
    if size(obj,2)>3
        objpos=obj(:,1:3);
        gray=obj(:,4);
    else
        objpos=obj;
        gray=[];
    end
end

if isempty(imgsize)
    mode{3}='ct';
end

if length(mode)==3
    switch mode{3}
    case 'ct'
        corner=min(objpos,[],1);
        % left=min(obj(:,1));
        % top=min(obj(:,2));
        reg=ml_objrecrange(objpos);
        if ~isempty(imgsize)
            ds=imgsize-reg;
            
            for i=1:length(ds)
                if(ds(i)<=2)
                    offset(i)=1;
                else
                    offset(i)=round(ds(i)/2);
                end
            end  
        else
            offset=ones(size(reg));
            imgsize=reg+2;
        end
        
        for i=1:length(reg)
            posoffset(i) = -corner(i)+1+offset(i);
            objpos(:,i)=objpos(:,i)+posoffset(i);
        end
    end
end

objects{1}=[objpos,gray];

img=ml_objs2img(objects,imgsize,mode);
