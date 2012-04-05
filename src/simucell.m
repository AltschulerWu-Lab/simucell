function simucell_result=simucell(filename,output_type,number_of_images)

addpath(genpath('gui'));
addpath(genpath('test'));
addpath(genpath('core'));
addpath(genpath('utils'));
addpath(genpath('plugins'));
addpath(genpath(['..' filesep 'saved_data']));
simucell_result=[];

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
                
                [file,path,filterindex] =uiputfile([ filename '.mat'],'Save simucell_data (*.mat)');
                if(filterindex ~= 0)
                    save([path file],'simucell_data');
                end
            case 'image'
                
                simucell_result=simucell_engine(simucell_data,number_of_images);
                figure;image(simucell_result(1).RGB_image);axis off; axis equal;
                if(number_of_images>1)
                    folder_name = uigetdir('.','Only first image shown. Pick a folder to save other images');
                       
                    if(~isnumeric(folder_name))
                        number_of_digits=floor(log10(number_of_images))+1;
                        for img_num=1:number_of_images
                            filename=[ folder_name filesep 'image_' sprintf(['%0' num2str(number_of_digits) 'd'],img_num) '.png'];
                            imwrite(simucell_result(img_num).RGB_image,filename);
                        end
                    end
                end
            case 'save_results'
                
                simucell_result=simucell_engine(simucell_data,number_of_images);
                [file,path,filterindex] =uiputfile(['results_' filename '.mat'],'Save simucell_results (*.mat)');
                if(filterindex ~= 0)
                    save([path file],'simucell_result');
                end
           
            otherwise
                error('Not a valid output_type');
        end
    end
    
end

end
