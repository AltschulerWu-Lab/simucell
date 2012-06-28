function color_group_struct=calculate_color_groups(subpopulations)
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

number_of_subpopulations=length(subpopulations);
subpop_number_list=[];
marker_name_list=cell(0);
marker_color_list=cell(0);
counter=1;
for subpop_number=1:number_of_subpopulations
  marker_names=properties(subpopulations{subpop_number}.markers);
  for marker_number=1:length(marker_names)
    marker_color_list{counter}=char(subpopulations{subpop_number}.markers.(marker_names{marker_number}).color);
    marker_name_list{counter}=marker_names{marker_number};
    subpop_number_list(counter)=subpop_number;
    counter=counter+1;
  end
end
[color_order,color_names]=grp2idx(marker_color_list);
number_of_colors=length(color_names);
color_group_struct=struct;
for color_number=1:number_of_colors
  markers_in_color=find(color_order==color_number);
  color_group_struct.(color_names{color_number})=cell(length(markers_in_color),2);
  for i=1:length(markers_in_color)
    color_group_struct.(color_names{color_number}){i,1}= subpop_number_list(markers_in_color(i));
    color_group_struct.(color_names{color_number}){i,2}= marker_name_list{markers_in_color(i)};
  end
end
