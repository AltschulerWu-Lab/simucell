classdef SLML_Nucleus_Model <SimuCell_Object_Model
  %SLML_Nucleus_Model nuclear shape model built using a model described via
  %an SLML file. For a description see Automated Learning of Generative Models for Subcellular 
  % Location: Building Blocks for Systems Biology. Cytometry 71A:978-990 by
  % T. Zhao and R.F. Murphy (2007)
  %
  %SLML_Nucleus_Model Properties:
  %   radius - Average Nuclear Radius
  %     Default value : 15
  %     Range value : 1 to Inf
  %   filename - path to an SLML file
  %     Default value : -
  %
  %Usage:
  %%Create a new Object 'nucleus'
  %add_object(subpop{2},'nucleus');
  %
  %%Set the Nucleus_Model model
  %subpop{2}.objects.nucleus.model=SLML_Nucleus_Model;
  %
  %Set the parameters
  %set(subpop{2}.objects.nucleus.model,'radius',60);
  %set(subpop{2}.objects.nucleus.model,'filename','data/slml/nucleolus.mat');
  %
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
  
  

  properties
    radius;
    filename;
    description=['A nuclear shape model built using a model'...
      ' described via an SLML file.'];
  end


  properties (Access=private)
    model
  end


  methods
    function obj=SLML_Nucleus_Model()
      obj.radius=Parameter('Nucleus Radius',15,...
        SimuCell_Class_Type.number,...
        [0,Inf],'Average Nuclear Radius');
      obj.filename=Parameter('SLML Filename',[],...
        SimuCell_Class_Type.file_name,...
        @isMatFile,'SLML Filename');
      addlistener(obj.filename,'Parameter_Set',@obj.update_model);
    end

    function output_shape=make_shape(obj,pos,current_image_mask,...
        prerendered_shapes)
      param.verbose = false;
      param.synthesize=[1 0 0];
      param.images = {};
      param = ml_initparam(param, ...
        struct('imageSize',[1024 1024],'gentex',0,'loc','all'));
      % nucimg=model2nuclei(model,param);
      [nucEdge,~] = ml_gencellcomp(obj.model, param );
      nucImage=imfill(nucEdge);
      [row,col]=find(nucImage>0);
      radius_created=...
        round(sqrt((max(row)-min(row))^2+(max(col)-min(col))^2)/2);
      nucImage=nucImage(min(row):max(row),min(col):max(col));
      nucImage1=imresize(nucImage>0,obj.radius.value/radius_created);
      output_shape=false(size(current_image_mask));
      nucleus_size=size(nucImage1);
      output_shape(pos(1)-floor(nucleus_size(1)/2-0.5):pos(1)-floor(nucleus_size(1)/2-0.5)+nucleus_size(1)-1,...
        pos(2)-floor(nucleus_size(2)/2-0.5):pos(2)-floor(nucleus_size(2)/2-0.5)+nucleus_size(2)-1)=logical(nucImage1);
    end

    function pre_obj_list=prerendered_object_list(obj)
      pre_obj_list=cell(0);
    end

    function obj=update_model(obj,passed_variable,passed_event)
      temp=load(obj.filename.value);
      obj.model=temp.model;
      disp('SLML nucleus model loaded successfully');
    end

  end


end
