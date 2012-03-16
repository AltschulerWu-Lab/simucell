function simucell_result=simucell(varargin)

  addpath(genpath('gui'));
  addpath(genpath('test'));
  addpath(genpath('engine'));
  addpath(genpath('utils'));
  addpath(genpath('plugins'));
  addpath(genpath(['..' filesep 'saved_data']));
  simucell_result=[];
  if(nargin>0)
      if( nargin ==1)
          eval(varargin{1});
          simucell_result=SimuCell_Engine(simucell_data);
      end
      
      if(nargin>1 && strcmp(varargin{2},'save_params'))
          eval(varargin{1});
          [file,path,filterindex] =uiputfile([ varargin{1} '.mat'],'Save simucell_data (*.mat)');
          if(filterindex ~= 0)
              save([path file],'simucell_data');
          end
      else
          
          if(nargin>1)
              switch(varargin{2})
                  case 'image'
                      eval(varargin{1});
                       simucell_result=SimuCell_Engine(simucell_data);
                      figure;image(simucell_result(1).RGB_image);axis off; axis equal;
                      
                  case 'save_results'
                      eval(varargin{1});
                      simucell_result=SimuCell_Engine(simucell_data);
                      [file,path,filterindex] =uiputfile(['results_' varargin{1} '.mat'],'Save simucell_results (*.mat)');
                      if(filterindex ~= 0)
                        save([path file],'simucell_result');
                      end
                  case 'show_results'
                      %TODO
                  case 'all_images'
                      %TODO
                  otherwise
                      error([varargin{2} ' is not a valid argument' ]);
              end
              
              
          end
      end
  end
        
end
