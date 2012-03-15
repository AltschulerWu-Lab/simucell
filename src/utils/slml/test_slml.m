clear all;
load 'endosome.mat';
%model1=slml2model('endosome.xml');
param.verbose = false;
param.synthesize=ones(1,size(model,2)+2);
param.images = {};
param = ml_initparam(param, ...
    struct('imageSize',[1024 1024],'gentex',0,'loc','all'));

% nucimg=model2nuclei(model,param);

[nucEdge,cellEdge] = ml_gencellcomp( model, param );
nucImage=imfill(nucEdge);


nucImage1=imresize(nucImage>0,0.25);
nucEdge1=edge(nucImage1);

nucImage=imfill(nucEdge);
nucImage=nucImage>0;

protimage = ml_genprotimg( model.proteinModel, nucEdge, cellEdge, param );

imagesc(nucEdge);