function [a,b,c,d]=simucell(varargin)

  addpath(genpath('gui'));
  addpath(genpath('test'));
  addpath(genpath('engine'));
  addpath(genpath('utils'));
  addpath(genpath('plugins'));

  if(nargin>0)
        [a,b,c,d]=eval(varargin{1});
  end
        
end
