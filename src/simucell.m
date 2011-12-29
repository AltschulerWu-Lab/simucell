function simucell(varargin)

  addpath(genpath('gui'));
  addpath(genpath('test'));
  addpath(genpath('engine'));
  addpath(genpath('utils'));
  addpath(genpath('plugins'));

  if(nargin>0)
        eval(varargin{1});
  end
        
end
