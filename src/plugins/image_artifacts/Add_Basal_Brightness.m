classdef Add_Basal_Brightness <SimuCell_ImageArtifact_Operation
  %Add_Basal_Brightness image artifact plugin used to add a basal level of
  %intensity to all pixels. Intensity saturates at 1.
  %
  %Add_Basal_Brightness Properties:
  %   basal_level   - Intensity added to to all pixels [0 -none, 1- full].
  %     Default value : 0.1
  %     Range value   : 0 to 1
  %
  %Usage:
  %op=Add_Basal_Brightness();
  %set(op,'basal_level',0.1);
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
    basal_level
    description=['Add a basal level of intensity to all pixels.'...
      ' Intensity saturates at 1'];
  end
  
  
  methods
    
    function obj=Add_Basal_Brightness()
      obj.basal_level=Parameter('Basal Level',0.1,...
        SimuCell_Class_Type.number, [0,1],...
        'Intensity added to to all pixels [0 -none, 1- full]');
    end
    
    function output_images=Apply(obj,input_images)
      number_of_channels=size(input_images,1);
      output_images=cell(number_of_channels,1);
      for channel=1:number_of_channels
        output_images{channel}=...
          min(input_images{channel}+obj.basal_level.value,1);
      end
    end    
    
  end
  
  
end
