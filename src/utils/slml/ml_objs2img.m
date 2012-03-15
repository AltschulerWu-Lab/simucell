function img=ml_objs2img(objects,imgsize,mode)
%ML_OBJS2IMG Convert objects to an image.
%   IMG = ML_OBJS2IMG(OBJECTS,IMGSIZE) returns a 2D image with the size
%   IMGSIZE. IMG contains all objects in the cell array OBJECTS except 
%   points outside of the image.
%   
%   IMG = ML_OBJS2IMG(OBJECTS,IMGSIZE,{MODE1,MODE2}) also specify the
%   mode of image synthesis:
%       MODE1:
%           '2d' - 2D image
%           '3d' - 3D image
%       MODE2:  
%           'og' - original pixel values in the objects
%           'bn' - binary image
%           'sg' - increasing gray leves for objects

%   18-Sep-2005 Initial write T. Zhao
%   ??-???-2004 Initial write T. Zhao
%   05-NOV-2004 Modified T. Zhao
%       - change funciton name tz_obj2img --> tz_objs2img

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

if ~exist('mode','var')
    mode{1}='2d';
    mode{2}='og';
end

img=zeros(imgsize);

for i=1:length(objects)
    %begin{26-JAN-2006}
    %t-
    %objects{i} = round(objects{i});
    %t--
    %t+
    objects{i}(:,1:2) = round(objects{i}(:,1:2));
    %t++  
    %end{26-JAN-2006}
    
    invalidpixels=ml_objinimg(objects{i},imgsize);
    
    if ~isempty(invalidpixels)
        warning('the object is located out of the image range');
        objects{i}(invalidpixels,:)=[];
    end
    
    switch mode{1}
    case '2d'
        switch mode{2}
        case 'og'
            
            if size(objects{i},2)<3
                img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2)))=1;
                %img((double(objects{i}(:,2))-1)*imgsize(1)+double(objects{i}(:,1)))=1;
            else
                img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2)))=objects{i}(:,3);
                %img((double(objects{i}(:,2))-1)*imgsize(1)+double(objects{i}(:,1)))=
            end
        case 'bn'
            img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2)))=1;
        case 'sg'
            img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2)))=i+50;
        end
    case '3d'
        switch mode{2}
         case 'og'
            
            if size(objects{i},2)<4
                img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2),objects{i}(:,3)))=1;
                %img((double(objects{i}(:,2))-1)*imgsize(1)+double(objects{i}(:,1)))=1;
            else
                img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2),objects{i}(:,3)))=objects{i}(:,4);
                %img((double(objects{i}(:,2))-1)*imgsize(1)+double(objects{i}(:,1)))=
            end
        case 'bn'
            img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2),objects{i}(:,3)))=1;
        case 'sg'
            img(sub2ind(imgsize,objects{i}(:,1),objects{i}(:,2),objects{i}(:,3)))=i+50;
        end   
    end
end

