classdef Cell_Staining_Artifacts <SimuCell_CellArtifact_Operation
%Cell_Staining_Artifacts cell artifact plugin used to make a specified
%subpopulation's fraction of cells blurred, to mimic an out of focal
%plane effect.
%
%Cell_Staining_Artifacts Properties:
%   fraction_bleached    - Proportion of cell which will bleached for the
%   specific subpopulation.
%     Default value : 0.1
%     Range value   : 0 to 1
%   fraction_unstained   - Proportion of cell which will unstained for 
%   the specific subpopulation.
%     Default value : 0.1
%     Range value   : 0 to 1
%   bleaching_multiplier - Intensities of bleached cells are scaled by 
%   this factor.
%     Default value : 5
%     Range value   : 0 to Inf
%   unstained_multiplier - Intensities of unstained cells are scaled by
%   this factor.
%     Default value : 0.1
%     Range value   : 0 to 1
%
%Usage:
%op=Cell_Staining_Artifacts();
%set(op,'fraction_bleached',1);
%set(op,'fraction_unstained',2);
%subpop{1}.add_cell_artifact(op);
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
    fraction_bleached
    fraction_unstained
    bleaching_multiplier
    unstained_multiplier
    description=['Model Bleached and Unstained Cells. The intensities'...
      ' for all markers in these cells are increased or decreased'];
  end
  
  
  methods
    
    function obj=Cell_Staining_Artifacts()
      obj.fraction_bleached=Parameter('Fraction of Bleached Cells',...
        0.1,SimuCell_Class_Type.number,...
        [0,1],'Fraction of Cells that are bleached, i.e. are super-bright');
      obj.fraction_unstained=Parameter('Fraction of Unstained Cells',...
        0.1,SimuCell_Class_Type.number,...
        [0,1],'Fraction of Cells that are un-stained, i.e. are super-dark');
      obj.bleaching_multiplier=Parameter('Bleached Intensity Multiplier',...
        5,SimuCell_Class_Type.number,...
        [1,Inf],'The intensities of bleached cells are scaled by this factor');
      obj.unstained_multiplier=Parameter('Unstained Intensity Multiplier',...
        0.1,SimuCell_Class_Type.number,...
        [0,1],'The intensities of unstained cells are scaled by this factor');
    end
    
    function output_images=Apply(obj,input_images)
      [number_of_cells,number_of_markers]=size(input_images);
      output_images=cell(number_of_cells,number_of_markers);
      for cell_number=1:number_of_cells
        type=discrete_prob([obj.fraction_bleached.value,obj.fraction_unstained.value,...
          1-(obj.fraction_bleached.value+obj.fraction_unstained.value)]);
        switch type
          case 1
            multiplier=obj.bleaching_multiplier.value;
          case 2
            multiplier=obj.unstained_multiplier.value;
          otherwise
            multiplier=1;
        end        
        for marker_number=1:number_of_markers
          output_images{cell_number,marker_number}=...
            max(min(multiplier*input_images{cell_number,marker_number},1),0);
        end        
      end      
    end
    
  end
  
  
end
