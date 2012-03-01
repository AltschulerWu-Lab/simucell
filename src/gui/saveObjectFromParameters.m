function objectToSave=saveObjectFromParameters(objectToSave,parametersFieldList,subpopulation)
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
      filepath=[];
      for j=1:length(childrenElement)
        filePath=get(childrenElement(j),'String');
        if(isMatFile(filePath))
          break;
        else
          filepath=[];
        end
      end
      if isempty(filepath)
        errordlg('The selected file is not an SLML file. Please make sure you selected a SLML file!');
        return;
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