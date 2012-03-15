function cellcode = ...
    ml_parsecell(cellcode,cellbody,nucbody,da,imgsize,selcodes,isshow)
%ML_PARSECELL Code cell morphology.
%   CELLCODE = 
%       ML_PARSECELL(CELLCODE,CELLBODY,NUCBODY,DA,IMGSIZE,SELCODES,ISSHOW)
%   returns a structure describing a cell. The input argument CELLCODE is 
%   the description from previous calculation. An existing field will not 
%   be updated. CELLBODY is an array of points (n1x2(3) matrix). NUCBODY is
%   also an array of points (n2x2(3) matrix). DA is the step size of coding
%   angles. IMGSIZE is the size of the original image. If ISSHOW is true,
%   the image will be shown. SELCODES is a cell array of strings, which are
%   feature names for calculation:
%       {'da','nucarea','nuccenter','nucmangle','nuchitpts',...
%         'nuccontour','nucellhitpts','nucdist','nucelldist',...
%         'nucecc','cellarea','cellcenter','cellmangle',...
%         'cellcontour','cellhitpts','celldist','cellecc'}
%   If SELCODES is empty, all features will be submitted for calculation.   
%
%   See also ML_COMBCCFEATS

%   ??-???-2005 Initial write T. Zhao
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

if nargin < 7
    error('Exactly 7 arguments are required')
end

%s2 is a structure to record which variables are ready
s2.cellbody=cellbody;
s2.nucbody=nucbody;
s2.da=da;
s2.imgsize=imgsize;

if isempty(cellcode)
    clear cellcode;
else
    %copy fields in cellcode to s2
    f=fieldnames(cellcode);
    for i=1:length(f)
        s2=setfield(s2,f{i},getfield(cellcode,f{i}));
    end 
end

if isempty(selcodes)
    selcodes = {'da','nucarea','nuccenter','nucmangle','nuchitpts',...
        'nuccontour','nucellhitpts','nucdist','nucelldist',...
        'nucecc','cellarea','cellcenter','cellmangle',...
        'cellcontour','cellhitpts','celldist','cellecc'};
end

%Calculate all required fields
s2=updates2(s2,selcodes);

%copy fields in s2 to cellcode
cellcode.da=s2.da;
for i=1:length(selcodes)
    cellcode=setfield(cellcode,selcodes{i},getfield(s2,selcodes{i}));
end

if isshow
    s2=updates2(s2,{'nucedge','celledge','nuccenter','len'});
    img=double(s2.nucedge)+double(s2.celledge);
    for a=0:45:359
        img=ml_setimglnpixel2(img,s2.nuccenter(1:2),a,s2.len);
    end
    
    imshow(img,[]);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
function s2=updates2(s2,f)

for i=1:length(f)
    if ~isfield(s2,f{i})
        switch f{i}
        case 'len'
            s2.len=sqrt(sum(s2.imgsize.^2));
        case 'cellarea'
            s2.cellarea=size(s2.cellbody,1);
        case 'nucarea'
            s2.nucarea=size(s2.nucbody,1);
        case 'cellecc'
            s2=updates2(s2,{'cellcenter'});
            cellbody(:,1:2)=ml_addrow(s2.cellbody(:,1:2),-s2.cellcenter);
            covmat=cov(cellbody(:,1),cellbody(:,2),1);
            mu20=covmat(1,1);
            mu02=covmat(2,2);
            mu11=covmat(1,2);
            mu00=size(cellbody,1);
            medresult=sqrt((mu20-mu02)^2+4*mu11^2);
            semimajor=sqrt(2*(mu20+mu02+medresult)/mu00);
            semiminor=sqrt(2*(mu20+mu02-medresult)/mu00);
            s2.cellecc=sqrt(semimajor^2-semiminor^2)/semimajor;
         case 'nucecc'
            s2=updates2(s2,{'nuccenter'});
            nucbody(:,1:2)=ml_addrow(s2.nucbody(:,1:2),-s2.nuccenter);
            covmat=cov(nucbody(:,1),nucbody(:,2),1);
            mu20=covmat(1,1);
            mu02=covmat(2,2);
            mu11=covmat(1,2);
            mu00=size(nucbody,1);
            medresult=sqrt((mu20-mu02)^2+4*mu11^2);
            semimajor=sqrt(2*(mu20+mu02+medresult)/mu00);
            semiminor=sqrt(2*(mu20+mu02-medresult)/mu00);
            s2.nucecc=sqrt(semimajor^2-semiminor^2)/semimajor;   
        case 'cellimg'
            s2.cellimg=ml_obj2img(s2.cellbody,s2.imgsize,{'2d','bn'});
        case 'nucimg'
            s2.nucimg=ml_obj2img(s2.nucbody,s2.imgsize,{'2d','bn'});
        case 'celledge'
            s2=updates2(s2,{'cellimg'});
            s2.celledge=bwperim(s2.cellimg,8);
        case 'cellcenter'
            s2.cellcenter=round(mean(s2.cellbody,1));
            %t+{27-Jan-2006}
            s2.cellcenter = s2.cellcenter(1:2);
            %t++
        case 'nuccenter'
            s2.nuccenter=round(mean(s2.nucbody,1));
            %t+{27-Jan-2006}
            s2.nuccenter = s2.nuccenter(1:2);
            %t++
        case 'nucedge'
            s2=updates2(s2,{'nucimg'});
            s2.nucedge=bwperim(s2.nucimg,8);
        case 'cellcontour'
            s2=updates2(s2,{'celledge'});
            s2.cellcontour=ml_tracecontour(ml_mainobjcontour(s2.celledge));
        case 'nuccontour'
            s2=updates2(s2,{'nucedge'});
            s2.nuccontour=ml_tracecontour(ml_mainobjcontour(s2.nucedge));
        case 'cellmangle'
            s2=updates2(s2,{'cellimg'});
            s2.cellmangle=ml_bwmajorangle(s2.cellimg)*180/pi;
        case 'nucmangle'
            s2=updates2(s2,{'nucimg'});
            s2.nucmangle=ml_bwmajorangle(s2.nucimg)*180/pi;
        case {'celldist','cellhitpts'}
            s2=updates2(s2,{'cellcenter','len','celledge'});
            s2.celldist=[];
            s2.cellhitpts=[];
            da=s2.da;
            if ~isempty(s2.celledge)
                for a=0:da:360-da
                    pts=ml_getlinept2(s2.cellcenter(1:2),a,s2.len);
                    ps=ml_imgptspixel(s2.celledge,pts);
                    intc2=find(ps>0);
                    
                    if ~isempty(intc2)                  
                        s2.cellhitpts=[s2.cellhitpts;pts(intc2(1),:)];
                        s2.celldist=[s2.celldist, ...
                            sqrt(sum((s2.cellcenter-s2.cellhitpts(end,:)).^2))];
                    else
                        imshow(ml_setimglnpixel2(double(s2.celledge), ...
                            s2.cellcenter(1:2),a,s2.len),[]);   
                    end
                end
            end
        case {'nucdist','nucelldist','nuchitpts','nucellhitpts'}            
            s2=updates2(s2,{'nuccenter','len','nucedge','celledge'});
            s2.nucdist=[];
            s2.nucelldist=[];
            s2.nucellhitpts=[];
            s2.nuchitpts=[];
            da=s2.da;
            if ~isempty(s2.nucbody)
                for a=0:da:360-da
                    pts=ml_getlinept2(s2.nuccenter(1:2),a,s2.len);
                    ps=ml_imgptspixel(s2.nucedge,pts);
                    intc1=find(ps>0);
                    
                    if isempty(s2.cellbody)
                        intc2=1;    %just not empty
                    else
                        ps=ml_imgptspixel(s2.celledge,pts);
                        intc2=find(ps>0);
                    end
                    
                    if ~isempty(intc1) & ~isempty(intc2)
                        
                        s2.nuchitpts=[s2.nuchitpts;pts(intc1(end),:)];
                        s2.nucdist=[s2.nucdist, ...
                            sqrt(sum((s2.nuccenter-s2.nuchitpts(end,:)).^2))];
                        if ~isempty(s2.cellbody)
                            s2.nucellhitpts=[s2.nucellhitpts;pts(intc2(1),:)];
                            s2.nucelldist=[s2.nucelldist, ...
                                sqrt(sum((s2.nuccenter-s2.nucellhitpts(end,:)).^2))];
                        end
                    else
                        if isempty(s2.celledge)
                            showimg=double(s2.nucedge);
                        else
                            showimg=double(s2.nucedge)+double(s2.celledge);
                        end
                        imshow(ml_setimglnpixel2(showimg, ...
                            s2.nuccenter(1:2),a,s2.len),[]);   
                    end
                end
            end
        end
    end
end
