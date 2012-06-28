classdef Fluid_Shape <SimuCell_Object_Model
  %Fluid_Shape cytoplasm model plugin creating an elliptical
  %cell, which turns fluid to avoid overlap.
  %
  %Fluid_Shape Properties:
  %   radius - Average Cell Radius
  %     Default value : 30
  %     Range value : 0 to Inf
  %   eccentricity - Measure of Non-Uniformity: 0=spherical, 1=straight line
  %     Default value : 0.5
  %     Range value : 0 to 1
  %   randomness - Measure of Non-Uniformity: 0=elliptical, 1=random
  %     Default value : 0.1
  %     Range value : 0 to 1
  %
  %Usage:
  %%Create a new Object 'cytoplasm'
  %add_object(subpop{2},'cytoplasm');
  %
  %%Set the Fluid_Shape model
  %subpop{2}.objects.cytoplasm.model=Fluid_Shape;
  %
  %Set the parameters
  %set(subpop{2}.objects.cytoplasm.model,'radius',60);
  %set(subpop{2}.objects.cytoplasm.model,'eccentricity',0.6);
  %set(subpop{2}.objects.cytoplasm.model,'randomness',0.2);
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
    eccentricity
    randomness
    description=['An elliptical model of cell shape, which turns'...
      ' fluid to avoid overlap'];
  end
  
  
  methods
    
    function obj=Fluid_Shape()
      obj.radius=Parameter('Cell Radius',30,SimuCell_Class_Type.number,...
        [0,Inf],'Average Cell Radius');
      obj.eccentricity=Parameter('Cell Eccentricity',0.5,SimuCell_Class_Type.number,...
        [0,1],'Measure of Non-Uniformity: 1=spherical, 0=straight line');
      obj.randomness=Parameter('Randomness',0.1,SimuCell_Class_Type.number,...
        [0,1],'Measure of Non-Uniformity: 0=elliptical,1= random');
    end
    
    function output_shape=make_shape(obj,pos,current_image_mask,prerendred_shapes)
      [max_x,max_y]=size(current_image_mask);
      intermediate_shape=elliptical_shape(obj.radius.value,obj.eccentricity.value,obj.randomness.value);
      temp_shape=false(size(current_image_mask));
      shape_size=size(intermediate_shape);
      %x=randi(obj.image_size(1)-shape_size(1));
      %y=randi(obj.image_size(2)-shape_size(2));
      x=pos(1);
      y=pos(2);
      temp_shape(x-floor(shape_size(1)/2-0.5):x-floor(shape_size(1)/2-0.5)+shape_size(1)-1,...
        y-floor(shape_size(2)/2-0.5):y-floor(shape_size(2)/2-0.5)+shape_size(2)-1)=logical(intermediate_shape);
      target_area=nnz(temp_shape);
      se=strel('line',2,2*pi*rand());
      max_attempts=50;
      attempt_num=1;
      temp_area=nnz(temp_shape&(~current_image_mask));
      current_image_maskI=~current_image_mask;
      allowed_shape=temp_shape&(current_image_maskI);
      while(temp_area<target_area && attempt_num<max_attempts)
        
        [rows,cols]=find(allowed_shape);
        x1=max(min(rows)-2,1);
        x2=min(max(rows)+2,max_x);
        y1=max(min(cols)-2,1);
        y2=min(max(cols)+2,max_y);

        temp=allowed_shape(x1:x2,y1:y2);
        temp=imdilate(temp,se);
        %temp_shape=false(max_x,max_y);
        allowed_shape=false(max_x,max_y);
        allowed_shape(x1:x2,y1:y2)=temp&(current_image_maskI(x1:x2,y1:y2));
        %temp_shape(x1:x2,y1:y2)=temp;
        
        %allowed_shape=temp_shape&(current_image_maskI);
        temp_area=nnz(allowed_shape(x1:x2,y1:y2));
        
        attempt_num=attempt_num+1;
      end
      output_shape=temp_shape&(~current_image_mask);
    end
    
    function pre_obj_list=prerendered_object_list(obj)
      pre_obj_list=cell(0);
    end
    
  end
  
  
end
