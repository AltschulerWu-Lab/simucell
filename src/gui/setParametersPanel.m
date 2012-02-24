function [parametersLabelList,parametersFieldList]=setParametersPanel(...
  hObject,handles,operationObj,...
  objectDescriptionHandle,handleName,clearParameter,allowed_types,...
  operationTypePopupMenu,parametersLabelList,parametersFieldList,...
  parentPanel,subpopulation)

set(objectDescriptionHandle,'String',operationObj.description);
propertyList = properties(operationObj);
myHandle=getappdata(0,handleName);
%Clear the all parameters
clearParameter();
%Populate the new one
paramNr=1;
top_ypos=140;
label_xpos=1;
box_xpos=205;
chosen_type=class(operationObj);
[truefalse, index] = ismember(chosen_type, allowed_types);
if(truefalse)
    set(operationTypePopupMenu,'Value',index);
end
for i=1:length(propertyList)
    if (~isa(operationObj.(propertyList{i}),'Parameter'))
        continue;
    end
    property=operationObj.get(propertyList{i});
    propertyName= operationObj.get(propertyList{i}).name;
    propertyAllowedValues= operationObj.get(propertyList{i}).allowed_values;
    
    parametersLabelList{paramNr}= uicontrol(...
        'Parent', parentPanel, 'Style', 'text',...
        'String', propertyName, 'Units', 'pixel',...
        'HorizontalAlignment','right',...
        'Position', [label_xpos top_ypos-(paramNr*30) 200 20], ...
        'FontWeight', 'normal',...
        'TooltipString', operationObj.get(propertyList{i}).description);
    
    %If the property is a number, use edit ui
    if(property.type==SimuCell_Class_Type.number)
        parametersFieldList{paramNr}= uicontrol(...
            'Parent', parentPanel, 'Style', 'edit',...
            'String', property.value, 'Units', 'pixel',...
            'HorizontalAlignment','left',...
            'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
            'FontWeight', 'normal',...
            'TooltipString', operationObj.get(propertyList{i}).description);
        
        
        %If the property is a list, use list ui
    elseif(property.type==SimuCell_Class_Type.list)
        
        [is_value_inlist, index] = ismember(property.value, propertyAllowedValues);
        
        parametersFieldList{paramNr}= uicontrol(...
            'Parent', parentPanel, 'Style', 'popupmenu',...
            'Value',index,'String', propertyAllowedValues, 'Units', 'pixel',...
            'HorizontalAlignment','left',...
            'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
            'FontWeight', 'normal',...
            'TooltipString', operationObj.get(propertyList{i}).description);
        %If the property is a simucell_shape_model, use list ui
    elseif(property.type==SimuCell_Class_Type.simucell_shape_model)
        objectList=properties(subpopulation.objects);
        if(isempty(objectList))
            warndlg({['You MUST have defined a object PREVIOUSLY in order to '...
                'use this model.'],
                'Please Cancel or choose and other Type/Model.'});
            setappdata(0,handleName,myHandle);
            handles=clearParameter();
            return;
        else            
            parametersFieldList{paramNr}= uicontrol(...
                'Parent', parentPanel, 'Style', 'popupmenu',...
                'String', objectList, 'Units', 'pixel',...
                'HorizontalAlignment','left',...
                'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
                'FontWeight', 'normal',...
                'TooltipString', operationObj.get(propertyList{i}).description);
            if(property.value~=0)
                name=subpopulation.find_shape_name(property.value);
                if(~isempty(name))
                    set(parametersFieldList{paramNr},...
                      'Value',find(strcmp(objectList, name)));
                end
            end
        end
    elseif(property.type==SimuCell_Class_Type.simucell_marker_model)
        marker_list=cell(0);
        markers=properties(subpopulation.markers);
        counter=1;
        for marker_num=1:length(markers)
            objects=properties(subpopulation.markers.(markers{marker_num}));
            for object_num=1:length(objects)
                if(isa(subpopulation.markers.(markers{marker_num}).(objects{object_num}),...
                        'Marker_Operation_Queue'))
                    marker_list{counter}=[markers{marker_num} '>' objects{object_num}];
                    counter=counter+1;
                end
            end
        end
        
        if(isempty(marker_list))
            warndlg({['You MUST have defined a marker PREVIOUSLY in order to '...
                'use this model.'],
                'Please Cancel or choose and other Type/Model.'});
            setappdata(0,handleName,myHandle);
            handles=clearParameter();
            return;
        else
            parametersFieldList{paramNr}= uicontrol(...
                'Parent', handles.mainPanel, 'Style', 'popupmenu',...
                'String', marker_list, 'Units', 'pixel',...
                'HorizontalAlignment','left',...
                'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
                'FontWeight', 'normal',...
                'TooltipString', operationObj.get(propertyList{i}).description);
            if(property.value~=0)
                [marker_name,shape_name]=subpopulation.find_marker_name(property.value);
                if(~isempty(marker_name))
                    set(parametersFieldList{paramNr},...
                      'Value',find(strcmp(marker_list, [marker_name '>' shape_name])));
                end
            end
        end
    end
    paramNr=paramNr+1;
end
% Update handles structure
setappdata(0,handleName,myHandle);
guidata(hObject, handles);