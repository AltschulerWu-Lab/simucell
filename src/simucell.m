function [a,b,c,d,e]=simucell(varargin)

  addpath(genpath('gui'));
  addpath(genpath('test'));
  addpath(genpath('engine'));
  addpath(genpath('utils'));
  addpath(genpath('plugins'));

  if(nargin>0)
        [a,b,c,d,e]=eval(varargin{1});
  end
        
end
