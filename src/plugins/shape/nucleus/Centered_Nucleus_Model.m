classdef Centered_Nucleus_Model <SimuCell_Object_Model
  %Centered_Nucleus_Model nucleus model plugin creating an elliptical
  %nucleus at the center of another shape (usually cytoplasm).
  % The model for the shape itself is a variation on the one used by 
  % Lehmussola et al in Proceedings of the IEEE, Vol. 96, No. 8. 
  % (16 July 2008), pp. 1348-1360, doi:10.1109/JPROC.2008.925490
  %
  %Centered_Nucleus_Model Properties:
  %   radius - Average Cell Radius.
  %     Default value : 30
  %     Range value : 0 to 100
  %   eccentricity - Measure of Non-Uniformity: 0=spherical, 1=straight
  %   line.
  %     Default value : 0.5
  %     Range value : 0 to 1
  %   randomness - Measure of Non-Uniformity: 0=elliptical, 1=random.
  %     Default value : 0.05
  %     Range value : 0 to 1
  %   centered_around - The nucleus is drawn at the center of this object
  %   (usually a cytoplasm).
  %     Default value : -
  %
  %Usage:
  %%Create a new Object 'nucleus'
  %add_object(subpop{2},'nucleus');
  %
  %%Set the Centered_Nucleus_Model model
  %subpop{2}.objects.nucleus.model=Centered_Nucleus_Model;
  %
  %Set the parameters
  %set(subpop{2}.objects.nucleus.model,'radius',60);
  %set(subpop{2}.objects.nucleus.model,'eccentricity',0.6);
  %set(subpop{2}.objects.nucleus.model,'randomness',0.2);
  %
  %%The nucleus is drawn at the center of the cytoplasm
  %set(subpop{2}.objects.nucleus.model,'centered_around',...
  %subpop{2}.objects.cytoplasm);
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
    eccentricity;
    randomness;
    centered_around;
    description=['A Model That Places an Elliptical Nucleus at the'...
      ' Center of Another Shape (Usually Cytoplasm)'];
  end
  
  
  methods
    function obj=Centered_Nucleus_Model()
      obj.radius=Parameter('Nuclear Radius',30,SimuCell_Class_Type.number,...
        [0,Inf],'Average Nuclear Radius');
      obj.eccentricity=Parameter('Nuclear Eccentricity',0.5,...
        SimuCell_Class_Type.number,...
        [0,1],'Measure of Non-Uniformity: 0=spherical, 1=straight line');
      obj.randomness=Parameter('Extent of Variation',0.05,...
        SimuCell_Class_Type.number,...
        [0,1],'Measure of Non-Uniformity: 0=elliptical,1= random');
      obj.centered_around=Parameter('Placed at Center Of',[],...
        SimuCell_Class_Type.simucell_shape_model, [],...
        'The nucleus is drawn at the center of this object (usually a cytoplasm)');
    end
    
    function output_shape=make_shape(obj,pos,current_image_mask,...
        prerendered_shapes)
      cytoplasm=prerendered_shapes{1};
      dist_mask=bwdist(~cytoplasm);
      [rad,I]=max(dist_mask(:));
      rad=0.9*rad;
      [x,y]=ind2sub(size(current_image_mask),I);
      intermediate_shape=elliptical_shape(min(obj.radius.value,rad),...
        obj.eccentricity.value,obj.randomness.value);
      output_shape=false(size(current_image_mask));
      shape_size=size(intermediate_shape);
      output_shape(x-floor(shape_size(1)/2-0.5):x-floor(shape_size(1)/2-0.5)+shape_size(1)-1,...
        y-floor(shape_size(2)/2-0.5):y-floor(shape_size(2)/2-0.5)+shape_size(2)-1)=logical(intermediate_shape);
    end
    
    function pre_obj_list=prerendered_object_list(obj)
      pre_obj_list={obj.centered_around.value};
    end
    
  end
  
  
end
