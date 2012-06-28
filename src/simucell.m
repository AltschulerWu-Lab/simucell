function simucell_result=simucell(filename,output_type,number_of_images)
%SIMUCELL Main SimuCell Function
%  SIMUCELL() will setup the path and display the version number. You can after
%  run simucellGUI to launch the graphical interface.
%  SIMUCELL_RESULT=SIMUCELL(FILENAME,OUTPUT_TYPE) will run a simucell script
%  stored in FILENAME (.m) and will output the result according to the OUT_TYPE
%  option choosed:
%    - save_params : will just save the parameters set in the .m script using
%    the same FILENAME basename into a .mat file. Will not run the fullscript
%   - image : will output the generated image. It will offer you to save this
%   image
%   - save_results : will run the script and offer you to save the result
%   into a mat file.
%  SIMUCELL_RESULT=SIMUCELL(FILENAME,'image',NUMBER_OF_IMAGES) will run a simucell
%  script stored in FILENAME (.m) and will display a generated image.
%  It will also ask for a folder to stored the NUMBER_OF_IMAGES you choosed to
%  generated.
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.SimuCell.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%
currentPath=pwd;
addpath(genpath([currentPath filesep 'gui']));
addpath(genpath([currentPath filesep 'test']));
addpath(genpath([currentPath filesep 'core']));
addpath(genpath([currentPath filesep 'utils']));
addpath(genpath([currentPath filesep 'plugins']));
addpath(genpath([currentPath filesep '..' filesep 'saved_data']));
simucell_result=[];

version=fileread('version.txt');
disp(['SimuCell version ' version]);

if(nargin<=2)
   number_of_images=1; 
end

if(nargin>0)
    if(exist(filename,'file'))
        eval(filename);
    else
       error('Not a valid file');
    end
    if(nargin==1)
        simucell_result=simucell_engine(simucell_data,1);
        figure;image(simucell_result(1).RGB_image);axis off; axis equal;
    else
        switch output_type
            case 'save_params'
                
                [file,path,filterindex] =uiputfile([ filename '.mat'],...
                  'Save simucell_data (*.mat)');
                if(filterindex ~= 0)
                    simucell_data.version=version;
                    save([path file],'simucell_data');
                end
            case 'image'
                
                simucell_result=simucell_engine(simucell_data,number_of_images);
                figure;image(simucell_result(1).RGB_image);axis off; axis equal;
                if(number_of_images>1)
                    folder_name = uigetdir('.',...
                    'Only first image shown. Pick a folder to save other images');
                       
                    if(~isnumeric(folder_name))
                        number_of_digits=floor(log10(number_of_images))+1;
                        for img_num=1:number_of_images
                            filename=[ folder_name filesep 'image_'...
                                       sprintf(['%0' num2str(number_of_digits) 'd'],...
                                       img_num) '.png'];
                            imwrite(simucell_result(img_num).RGB_image,filename);
                        end
                    end
                end
            case 'save_results'
                
                simucell_result=simucell_engine(simucell_data,number_of_images);
                [file,path,filterindex] =uiputfile(['results_' filename '.mat'],...
                  'Save simucell_results (*.mat)');
                if(filterindex ~= 0)
                    save([path file],'simucell_result');
                end
           
            otherwise
                error('Not a valid output_type');
        end
    end
    
end

end
