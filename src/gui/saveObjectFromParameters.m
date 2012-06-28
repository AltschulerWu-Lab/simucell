function objectToSave=saveObjectFromParameters(objectToSave,parametersFieldList,subpopulation)
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

%Get the property setted for this new object
propertyList = properties(objectToSave);
paramNr=1;
for i=1:length(propertyList)
    if (~isa(objectToSave.(propertyList{i}),'Parameter'))
        continue;
    end
    if(objectToSave.(propertyList{i}).type==SimuCell_Class_Type.number)
        propertyValue=get(parametersFieldList{paramNr},'String');
        try
            propertyValue=str2double(propertyValue);
        catch
            ;
        end
          
    elseif(objectToSave.(propertyList{i}).type==SimuCell_Class_Type.file_name)
      childrenElement=get(parametersFieldList{paramNr},'Children');
      filePath=[];
      for j=1:length(childrenElement)
        filePath=get(childrenElement(j),'String');
        if(isMatFile(filePath))
          break;
        else
          filePath=[];
        end
      end
      if isempty(filePath)
        errordlg('The selected file is not an SLML file. Please make sure you selected a SLML file!');
        return;
      else
        propertyValue=filePath;
        
      end
        
    elseif(objectToSave.(propertyList{i}).type==SimuCell_Class_Type.list)
        propertyValue=get(parametersFieldList{i},'String');
        propertyIndex=get(parametersFieldList{i},'Value');
        
        propertyValue=propertyValue{propertyIndex};
    elseif(objectToSave.(propertyList{i}).type==SimuCell_Class_Type.simucell_shape_model)
        propertyValue=get(parametersFieldList{i},'String');
        propertyIndex=get(parametersFieldList{i},'Value');
        
        propertyValue=subpopulation.objects.(propertyValue{propertyIndex});
        
    elseif(objectToSave.(propertyList{i}).type==SimuCell_Class_Type.simucell_marker_model)
        propertyValue=get(parametersFieldList{i},'String');
        propertyIndex=get(parametersFieldList{i},'Value');
        split_vals=regexpi(propertyValue{propertyIndex},'>','split');
        
        propertyValue=subpopulation.markers.(split_vals{1}).(split_vals{2});
    end
    %Set the value to the corresponding parameter
    set(objectToSave,propertyList{i},propertyValue);
    paramNr=paramNr+1;
end
