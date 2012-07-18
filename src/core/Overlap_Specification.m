classdef Overlap_Specification <handle
%Overlap_Specification class used to define how shape will overlap
%
%Overlap_Specification Properties: (Private)
%
%Overlap_Specification Methods:
%  AddOverlap - Set the overlapp values between a list of objects
%    -object_list:   the list of object
%    -overlap_value: the overlap value 0- no overlapp, 1 full overlap
%    allowed (1 shape can 100% overlap the other one).
%       Range Value: 0 to 1
%
%  construct_overlap_matrix - build the overlap matrix
%    -subpopulations: subpopulations strcuture containing the full
%    subpopulations information. Used internally by the engine.
%
%Usage:
%overlap=Overlap_Specification;
%overlap.AddOverlap({subpop{1}.objects.cytoplasm,...
%  subpop{2}.objects.cytoplasm},0.05);
%simucell_data.overlap=overlap;
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
  
  
  properties %(SetAccess=private)
    overlap_lists
    overlap_matrix
    overlap_values
    ordered_shape_list
    shape_to_number_map    
  end
  
  
  methods
    
    function obj=Overlap_Specification()
      obj.overlap_lists={{}};
      obj.overlap_values=[];
    end
    
    function AddOverlap(obj,object_list,overlap_value)
      obj.overlap_values=[obj.overlap_values(:) overlap_value];
      if(~isempty(obj.overlap_lists{end}))
        obj.overlap_lists=[obj.overlap_lists {object_list}];
      else
        obj.overlap_lists={object_list};
      end
    end    
    
    function construct_overlap_matrix(obj,subpopulations)
      obj.ordered_shape_list=cell(0);
      obj.shape_to_number_map=cell(0);
      number_of_subpopulations=length(subpopulations);
      shape_counter=0;
      subpop_of_shape=[];
      for subpop=1:number_of_subpopulations
        shapes= properties(subpopulations{subpop}.objects);
        obj.shape_to_number_map{subpop}=containers.Map;
        for i=1:length(shapes)
          shape_counter=shape_counter+1;
          obj.ordered_shape_list=[obj.ordered_shape_list,...
            {subpopulations{subpop}.objects.(shapes{i})}];
          obj.shape_to_number_map{subpop}(shapes{i})=shape_counter;
          subpop_of_shape(end+1)=subpop;
        end
      end
      obj.overlap_matrix=ones(length(obj.ordered_shape_list));      
      if(~all(cellfun('isempty',obj.overlap_lists)))
        for list_counter=1:length(obj.overlap_lists)
          temp_list=obj.overlap_lists{list_counter};
          for i=1:length(temp_list)
            %Going to i (rather than i-1) ensures that self-overlap is 
            %given the same value 
            for j=1:i              
              n1=find(cellfun(@(x) x==temp_list{i},...
                obj.ordered_shape_list),1);
              n2=find(cellfun(@(x) x==temp_list{j},...
                obj.ordered_shape_list),1);
              obj.overlap_matrix(n1,n2)=obj.overlap_values(list_counter);
              obj.overlap_matrix(n2,n1)=obj.overlap_values(list_counter);
            end
          end
        end
        for list_counter=1:length(obj.overlap_lists)
          temp_list=obj.overlap_lists{list_counter};
          if(length(temp_list)==1)
            n1=find(cellfun(@(x) x==temp_list{1},...
              obj.ordered_shape_list),1);
            obj.overlap_matrix(n1,n1)=obj.overlap_values(list_counter);
          end
        end
      else
        for i=1:length(obj.ordered_shape_list)
          obj.overlap_matrix(i,subpop_of_shape~=subpop_of_shape(i))=0;
          obj.overlap_matrix(i,i)=0;
        end
      end
    end
    
  end
  
  
end
