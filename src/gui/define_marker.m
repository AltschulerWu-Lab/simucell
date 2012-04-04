function varargout = define_marker(varargin)
% DEFINE_MARKER MATLAB code for define_marker.fig
%      DEFINE_MARKER, by itself, creates a new DEFINE_MARKER or raises the existing
%      singleton*.
%
%      H = DEFINE_MARKER returns the handle to a new DEFINE_MARKER or the handle to
%      the existing singleton*.
%
%      DEFINE_MARKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_MARKER.M with the given input arguments.
%
%      DEFINE_MARKER('Property','Value',...) creates a new DEFINE_MARKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_marker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_marker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_marker

% Last Modified by GUIDE v2.5 15-Feb-2012 16:25:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @define_marker_OpeningFcn, ...
    'gui_OutputFcn',  @define_marker_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before define_marker is made visible.
function define_marker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_marker (see VARARGIN)

% Choose default command line output for define_marker
handles.output = hObject;
if (length(varargin) < 5) %|| ~isa(varargin{1}, 'importantObjectType')
    error ('you must pass your object name and subpopulation nr');
end
markerHandles.subpop = varargin{1};
markerHandles.markerProperty = varargin{2};
markerHandles.markerName=varargin{3};
markerHandles.objectName=varargin{4};
markerHandles.subpopNr=varargin{5};
markerHandles.temp_operation_queue=markerHandles.markerProperty.operations;

setappdata(0,'markerHandles',markerHandles);
fileList=dir(['plugins' filesep 'markers' filesep '*.m']);
fileList = {fileList(find([fileList.isdir]==0)).name};

for i=1:length(fileList)
    fileList{i}=fileList{i}(1:end-2);
end
set(handles.operation_type_popupmenu,'String',fileList);
set(handles.objectCB,'String',{markerHandles.objectName});
updateOperationList(hObject, eventdata, handles);
operationListbox_Callback(hObject, eventdata, handles);
set(handles.markerLabel,'String',markerHandles.markerName);
set(handles.subpopNrLabel,'String',num2str(markerHandles.subpopNr));
mc = ?Colors;
nrColor = length(mc.EnumeratedValues);
for i=1:nrColor
  colorList{1,i}=mc.EnumeratedValues{i}.Name;
end
%markerColor=markerHandles.subpop.markers.(markerHandles.markerName).color.char;
markerColor=char(markerHandles.subpop.markers.(markerHandles.markerName).color);
idxCell=strfind(colorList,markerColor);
isFound = ~cellfun('isempty', idxCell); % Returns "0" if idxCell is empty and a "1" otherwise
foundIdx = find(isFound);
set(handles.colorCB,'String',colorList);
set(handles.colorCB,'Value',foundIdx);

% Update handles structure
guidata(hObject, handles);
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_marker_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
markerHandles=getappdata(0,'markerHandles');
varargout{1}=markerHandles.markerProperty;
varargout{2}=markerHandles.markerName;
colorList=get(handles.colorCB,'String');
colorIndex=get(handles.colorCB,'Value');
varargout{3}=colorList{colorIndex};
if(~isempty(handles))
  delete(handles.figure1);
end


% --- Executes on selection change in operationListbox.
function operationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to operationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerHandles=getappdata(0,'markerHandles');
%Get the description of the first selected Model
%selectedString=get(handles.operationListbox,'String');
selectedValue=get(handles.operationListbox,'Value');
if(isempty(markerHandles.temp_operation_queue))
  hideOperationParameterPanel(handles,'off');
  return;
else  
  hideOperationParameterPanel(handles,'on');
end
markerObj=markerHandles.temp_operation_queue{selectedValue};
%markerObj=eval(selectedString{selectedValue});
set(handles.descriptionText,'String',markerObj.description);
setShapeParametersPanel(hObject,handles,markerObj,markerHandles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function operationListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addOperationButton.
function addOperationButton_Callback(hObject, eventdata, handles)
% hObject    handle to addOperationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerHandles=getappdata(0,'markerHandles');
markerHandles.temp_operation_queue{end+1}=Constant_Marker_Level();
setappdata(0,'markerHandles',markerHandles);
updateOperationList(hObject, eventdata, handles);
set(handles.operationListbox,'Value',length(markerHandles.temp_operation_queue));
guidata(hObject, handles);
operationListbox_Callback(hObject, eventdata, handles);


% --- Executes on button press in removeOperationButton.
function removeOperationButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeOperationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerHandles=getappdata(0,'markerHandles');
operation_to_remove=get(handles.operationListbox,'Value');
markerHandles.temp_operation_queue =...
  removeFromCellArray(markerHandles.temp_operation_queue,operation_to_remove);
setappdata(0,'markerHandles',markerHandles);
updateOperationList(hObject, eventdata, handles);
set(handles.operationListbox,'Value',max(get(handles.operationListbox,'Value')-1,1));
guidata(hObject, handles);
operationListbox_Callback(hObject, eventdata, handles);


% --- Executes on selection change in subpopCB.
function subpopCB_Callback(hObject, eventdata, handles)
% hObject    handle to subpopCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function subpopCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subpopCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in markerCB.
function markerCB_Callback(hObject, eventdata, handles)
% hObject    handle to markerCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns markerCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from markerCB


% --- Executes during object creation, after setting all properties.
function markerCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to markerCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in colorCB.
function colorCB_Callback(hObject, eventdata, handles)
% hObject    handle to colorCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns colorCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colorCB


% --- Executes during object creation, after setting all properties.
function colorCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colorCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerHandles=getappdata(0,'markerHandles');
%Get the Object Type
selectedString=get(handles.operation_type_popupmenu,'String');
selectedValue=get(handles.operation_type_popupmenu,'Value');
%Create new Shape Model Object
markerObj=eval(selectedString{selectedValue});
markerObj=saveObjectFromParameters(markerObj,...
   markerHandles.parametersField,markerHandles.subpop);
%Save the created Object
operation_number=get(handles.operationListbox,'Value');
markerHandles.temp_operation_queue{operation_number}=markerObj;
%Save the handle
setappdata(0,'markerHandles',markerHandles);
updateOperationList(hObject, eventdata, handles);
guidata(hObject, handles);
set(handles.operationListbox,'Value',operation_number);
guidata(hObject, handles);
setappdata(0,'markerHandles',markerHandles);


% --- Executes on selection change in objectCB.
function objectCB_Callback(hObject, eventdata, handles)
% hObject    handle to objectCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns objectCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from objectCB


% --- Executes during object creation, after setting all properties.
function objectCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objectCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in viewButton.
function viewButton_Callback(hObject, eventdata, handles)
% hObject    handle to viewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function updateOperationList(hObject, eventdata, handles)
markerHandles=getappdata(0,'markerHandles');
operation_names=cell(length(markerHandles.temp_operation_queue),1);
for op_number=1:length(markerHandles.temp_operation_queue)
    operation_names{op_number}=class(markerHandles.temp_operation_queue{op_number});
end
set(handles.operationListbox,'String',operation_names);
guidata(hObject, handles);


function setShapeParametersPanel(hObject,handles,operationObj,markerHandles)
objectDescriptionHandle=handles.descriptionText;
handleName='markerHandles';
allowed_types=get(handles.operation_type_popupmenu,'String');
operationTypePopupMenu=handles.operation_type_popupmenu;
markerHandles.parametersLabel=[];
markerHandles.parametersField=[];
parametersLabelList=markerHandles.parametersLabel;
parametersFieldList=markerHandles.parametersField;
parentPanel=handles.mainPanel;
subpopulation=markerHandles.subpop;
[parametersLabelList,parametersFieldList]=setParametersPanel(hObject,handles,...
  operationObj,objectDescriptionHandle,handleName,...
  @clearAllParameters,...
  allowed_types,operationTypePopupMenu,parametersLabelList,...
  parametersFieldList,parentPanel,subpopulation);
markerHandles.parametersLabel=parametersLabelList;
markerHandles.parametersField=parametersFieldList;
setappdata(0,'markerHandles',markerHandles);




% function setParametersPanel(hObject,handles,markerObj)
% propertyList = properties(markerObj);
% 
% markerHandles=getappdata(0,'markerHandles');
% %Clear the all parameters
% clearAllParameters();
% %Populate the new one
% paramNr=1;
% top_ypos=170;
% label_xpos=1;
% box_xpos=205;
% allowed_types=get(handles.operation_type_popupmenu,'String');
% chosen_type=class(markerObj);
% [truefalse, index] = ismember(chosen_type, allowed_types);
% if(truefalse)
%     set(handles.operation_type_popupmenu,'Value',index);
% end
% for i=1:length(propertyList)
%     %if(strcmpi(propertyList{i},'description'))
%     if (~isa(markerObj.(propertyList{i}),'Parameter'))
%         continue;
%     end
%     property=markerObj.get(propertyList{i});
%     propertyName= markerObj.get(propertyList{i}).name;
%     propertyAllowedValues= markerObj.get(propertyList{i}).allowed_values;
%     
%     markerHandles.parametersLabel{paramNr}= uicontrol(...
%         'Parent', handles.mainPanel, 'Style', 'text',...
%         'String', propertyName, 'Units', 'pixel',...
%         'HorizontalAlignment','right',...
%         'Position', [label_xpos top_ypos-(paramNr*30) 200 20], ...
%         'FontWeight', 'normal',...
%         'TooltipString', markerObj.get(propertyList{i}).description);
%     
%     %If the property is a number, use edit ui
%     if(property.type==SimuCell_Class_Type.number)
%         markerHandles.parametersField{paramNr}= uicontrol(...
%             'Parent', handles.mainPanel, 'Style', 'edit',...
%             'String', property.value, 'Units', 'pixel',...
%             'HorizontalAlignment','left',...
%             'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
%             'FontWeight', 'normal',...
%             'TooltipString', markerObj.get(propertyList{i}).description);
%         
%         
%         %If the property is a list, use list ui
%     elseif(property.type==SimuCell_Class_Type.list)
%         
%         [is_value_inlist, index] = ismember(property.value, propertyAllowedValues);
%         
%         markerHandles.parametersField{paramNr}= uicontrol(...
%             'Parent', handles.mainPanel, 'Style', 'popupmenu',...
%             'Value',index,'String', propertyAllowedValues, 'Units', 'pixel',...
%             'HorizontalAlignment','left',...
%             'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
%             'FontWeight', 'normal',...
%             'TooltipString', markerObj.get(propertyList{i}).description);
%         %If the property is a simucell_shape_model, use list ui
%     elseif(property.type==SimuCell_Class_Type.simucell_shape_model)
%         objectList=properties(markerHandles.subpop.objects);
%         if(isempty(objectList))
%             warndlg({['You MUST have defined a object PREVIOUSLY in order to '...
%                 'use this model.'],
%                 'Please Cancel or choose and other Type/Model.'});
%             setappdata(0,'markerHandles',markerHandles);
%             handles=clearAllParameters();
%             %       markerHandles=getappdata(0,'markerHandles');
%             %       setappdata(0,'markerHandles',markerHandles);
%             %guidata(hObject, handles);
%             return;
%         else
%             %objectNameList=fieldnames(markerHandles.objects);
%             
%             markerHandles.parametersField{paramNr}= uicontrol(...
%                 'Parent', handles.mainPanel, 'Style', 'popupmenu',...
%                 'String', objectList, 'Units', 'pixel',...
%                 'HorizontalAlignment','left',...
%                 'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
%                 'FontWeight', 'normal',...
%                 'TooltipString', markerObj.get(propertyList{i}).description);
%             if(property.value~=0)
%                 name=markerHandles.subpop.find_shape_name(property.value);
%                 if(~isempty(name))
%                     set(markerHandles.parametersField{paramNr},'Value',find(strcmp(objectList, name)));
%                 end
%             end
%         end
%     elseif(property.type==SimuCell_Class_Type.simucell_marker_model)
%         marker_list=cell(0);
%         markers=properties(markerHandles.subpop.markers);
%         counter=1;
%         for marker_num=1:length(markers)
%             objects=properties(markerHandles.subpop.markers.(markers{marker_num}));
%             for object_num=1:length(objects)
%                 if(isa(markerHandles.subpop.markers.(markers{marker_num}).(objects{object_num}),...
%                         'Marker_Operation_Queue'))
%                     marker_list{counter}=[markers{marker_num} '>' objects{object_num}];
%                     counter=counter+1;
%                 end
%             end
%         end
%         if(isempty(marker_list))
%             warndlg({['You MUST have defined a marker PREVIOUSLY in order to '...
%                 'use this model.'],
%                 'Please Cancel or choose and other Type/Model.'});
%             setappdata(0,'markerHandles',markerHandles);
%             handles=clearAllParameters();
%             %       markerHandles=getappdata(0,'markerHandles');
%             %       setappdata(0,'markerHandles',markerHandles);
%             %guidata(hObject, handles);
%             return;
%         else
%             markerHandles.parametersField{paramNr}= uicontrol(...
%                 'Parent', handles.mainPanel, 'Style', 'popupmenu',...
%                 'String', marker_list, 'Units', 'pixel',...
%                 'HorizontalAlignment','left',...
%                 'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
%                 'FontWeight', 'normal',...
%                 'TooltipString', markerObj.get(propertyList{i}).description);
%             if(property.value~=0)
%                 [marker_name,shape_name]=markerHandles.subpop.find_marker_name(property.value);
%                 if(~isempty(marker_name))
%                     set(markerHandles.parametersField{paramNr},...
%                       'Value',find(strcmp(marker_list, [marker_name '>' shape_name])));
%                 end
%             end
%         end
%     end
%     paramNr=paramNr+1;
% end
% % Update handles structure
% setappdata(0,'markerHandles',markerHandles);
% guidata(hObject, handles);


%Remove all previous Model parameters
function handles=clearAllParameters()
%Clear the all parameters
markerHandles=getappdata(0,'markerHandles');
if isfield(markerHandles,'parametersLabel')
    for i=1:length(markerHandles.parametersLabel)
        if(ishandle(markerHandles.parametersLabel{i}))
            delete(markerHandles.parametersLabel{i});
        end
    end
    handles=rmfield(markerHandles,'parametersLabel');
end
if isfield(markerHandles,'parametersField')
    for i=1:length(markerHandles.parametersField)
        if(ishandle(markerHandles.parametersField{i}))
            delete(markerHandles.parametersField{i});
        end
    end
    handles=rmfield(markerHandles,'parametersField');
    setappdata(0,'markerHandles',markerHandles);
end


% --- Executes on selection change in operation_type_popupmenu.
function operation_type_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to operation_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerHandles=getappdata(0,'markerHandles');
%Get the description of the first selected Model
selectedString=get(handles.operation_type_popupmenu,'String');
selectedValue=get(handles.operation_type_popupmenu,'Value');
%markerObj=markerHandles.temp_operation_queue.operations{selectedValue};
markerObj=eval(selectedString{selectedValue});
set(handles.descriptionText,'String',markerObj.description);
setShapeParametersPanel(hObject,handles,markerObj,markerHandles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function operation_type_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operation_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%markerHandles=getappdata(0,'markerHandles');
%markerHandles.markerProperty.operations=[];
%setappdata(0,'markerHandles',markerHandles);
uiresume(handles.figure1);


% --- Executes on button press in DoneButton.
function DoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to DoneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
markerHandles=getappdata(0,'markerHandles');
%Replace in Marker Property Object the variable operations by the temp one
%So Modify the Marker Property Object therefore no need to return or save
%it (since it overclass handle, it is saved by reference).
markerHandles.markerProperty.operations=markerHandles.temp_operation_queue;
setappdata(0,'markerHandles',markerHandles);
uiresume(handles.figure1);


function hideOperationParameterPanel(handles,isVisible)
set(handles.text2,'Visible',isVisible);
set(handles.operation_type_popupmenu,'Visible',isVisible);
set(handles.SaveButton,'Visible',isVisible);
set(handles.viewButton,'Visible',isVisible);
