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

% Last Modified by GUIDE v2.5 09-Jan-2012 02:04:59

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
% handles.object_name = varargin{1};
% handles.subpop_nr = varargin{2};
% handles.objects=varargin{3};
% handles.currentObject=varargin{4};
% handles.subpop=varargin{5};


shapeHandles.subpop = varargin{1};
shapeHandles.markerProperty = varargin{2};
shapeHandles.markerName=varargin{3};
shapeHandles.objectName=varargin{4};
shapeHandles.subpopNr=varargin{4};
shapeHandles.temp_operation_queue=shapeHandles.markerProperty.CloneOperationQueue();

setappdata(0,'shapeHandles',shapeHandles);
fileList=dir('plugins/markers/');
fileList = {fileList(find([fileList.isdir]==0)).name};

for i=1:length(fileList)
    fileList{i}=fileList{i}(1:end-2);
end
set(handles.operation_type_popupmenu,'String',fileList);
set(handles.objectCB,'String',{shapeHandles.objectName});

% if(~isempty(shapeHandles.selectedType))
%   valueSelected=find(strcmp(dirList, shapeHandles.selectedType));
%   %Set the shape Type
%   set(handles.shapeTypeCb,'String',dirList,'Value',valueSelected);
%   %Set the shape Model
%   guidata(hObject, handles);
%   shapeTypeCb_Callback(hObject, eventdata, handles);
%   modelList=get(handles.shapeModelCb,'String');
%
%   valueSelected=find(strcmp(modelList, shapeHandles.selectedModel));
%   set(handles.shapeModelCb,'Value',valueSelected);
%
%
%   %Set the parameters field
%   setParametersPanel(hObject,handles,shapeHandles.currentObject);
%
% else
%   set(handles.shapeTypeCb,'String',dirList);
% end
updateOperationList(hObject, eventdata, handles);




% set(handles.title,'String',['Define marker ' shapeHandles.markerName...
%   ' for object ' shapeHandles.objectName...
%   ' of subpopulation ' num2str(shapeHandles.subpopNrsubpopNr)]);
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
shapeHandles=getappdata(0,'shapeHandles');
varargout{1}=shapeHandles.markerProperty;
varargout{2}=shapeHandles.markerName;

delete(handles.figure1);


% --- Executes on selection change in operationListbox.
function operationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to operationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% shapeHandles=getappdata(0,'shapeHandles');
% operation_to_remove=get(handles.operationListbox,'Value');
% shapeHandles.markerProperty.DeleteOperation(operation_to_remove);
% setappdata(0,'shapeHandles',shapeHandles);
% updateOperationList(hObject, eventdata, handles);

shapeHandles=getappdata(0,'shapeHandles');
%Get the description of the first selected Model
%selectedString=get(handles.operationListbox,'String');
selectedValue=get(handles.operationListbox,'Value');
shapeObj=shapeHandles.temp_operation_queue.operations{selectedValue};
%shapeObj=eval(selectedString{selectedValue});
set(handles.descriptionText,'String',shapeObj.description);
setParametersPanel(hObject,handles,shapeObj);
guidata(hObject, handles);

% Hints: contents = cellstr(get(hObject,'String')) returns operationListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from operationListbox


% --- Executes during object creation, after setting all properties.
function operationListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addOperationButton.
function addOperationButton_Callback(hObject, eventdata, handles)
% hObject    handle to addOperationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shapeHandles=getappdata(0,'shapeHandles');
shapeHandles.temp_operation_queue.AddOperation(Constant_marker_level_operation());
setappdata(0,'shapeHandles',shapeHandles);
updateOperationList(hObject, eventdata, handles);
set(handles.operationListbox,'Value',length(shapeHandles.temp_operation_queue.operations));
guidata(hObject, handles);
operationListbox_Callback(hObject, eventdata, handles);




% --- Executes on button press in removeOperationButton.
function removeOperationButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeOperationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shapeHandles=getappdata(0,'shapeHandles');
operation_to_remove=get(handles.operationListbox,'Value');
shapeHandles.temp_operation_queue.DeleteOperation(operation_to_remove);
setappdata(0,'shapeHandles',shapeHandles);
updateOperationList(hObject, eventdata, handles);
set(handles.operationListbox,'Value',max(get(handles.operationListbox,'Value')-1,1));
guidata(hObject, handles);
operationListbox_Callback(hObject, eventdata, handles);




% --- Executes on selection change in subpopCB.
function subpopCB_Callback(hObject, eventdata, handles)
% hObject    handle to subpopCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subpopCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subpopCB


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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

shapeHandles=getappdata(0,'shapeHandles');
%Get the Object Type
selectedString=get(handles.operation_type_popupmenu,'String');
selectedValue=get(handles.operation_type_popupmenu,'Value');
%Create new Shape Model Object
shapeObj=eval(selectedString{selectedValue});

%Get the property setted for this new object
propertyList = properties(shapeObj);
paramNr=1;
for i=1:length(propertyList)
    if (~isa(shapeObj.(propertyList{i}),'Parameter'))
        continue;
    end
    if(shapeObj.(propertyList{i}).type==SimuCell_Class_Type.number)
        propertyValue=get(shapeHandles.parametersField{paramNr},'String');
        try
            propertyValue=str2double(propertyValue);
        catch
            ;
        end
    elseif(shapeObj.(propertyList{i}).type==SimuCell_Class_Type.list)
        propertyValue=get(shapeHandles.parametersField{i},'String');
        propertyIndex=get(shapeHandles.parametersField{i},'Value');
        
        propertyValue=propertyValue{propertyIndex};
    elseif(shapeObj.(propertyList{i}).type==SimuCell_Class_Type.simucell_shape_model)
        propertyValue=get(shapeHandles.parametersField{i},'String');
        propertyIndex=get(shapeHandles.parametersField{i},'Value');
        
        propertyValue=shapeHandles.subpop.objects.(propertyValue{propertyIndex});
        
    elseif(shapeObj.(propertyList{i}).type==SimuCell_Class_Type.simucell_marker_model)
        propertyValue=get(shapeHandles.parametersField{i},'String');
        propertyIndex=get(shapeHandles.parametersField{i},'Value');
        split_vals=regexpi(propertyValue{propertyIndex},'>','split');
        
        propertyValue=shapeHandles.subpop.markers.(split_vals{1}).(split_vals{2});
    end
    %Set the value to the corresponding parameter
    set(shapeObj,propertyList{i},propertyValue);
    paramNr=paramNr+1;
end
%Save the created Object
operation_number=get(handles.operationListbox,'Value');
shapeHandles.temp_operation_queue.operations{operation_number}=shapeObj;
updateOperationList(hObject, eventdata, handles);
guidata(hObject, handles);
%close(handles.figure1);
setappdata(0,'shapeHandles',shapeHandles);
%uiresume;




% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function updateOperationList(hObject, eventdata, handles)
shapeHandles=getappdata(0,'shapeHandles');
operation_names=cell(length(shapeHandles.temp_operation_queue.operations),1);
for op_number=1:length(shapeHandles.temp_operation_queue.operations)
    operation_names{op_number}=class(shapeHandles.temp_operation_queue.operations{op_number});
end
set(handles.operationListbox,'String',operation_names);
guidata(hObject, handles);




function setParametersPanel(hObject,handles,markerObj)
propertyList = properties(markerObj);


shapeHandles=getappdata(0,'shapeHandles');
%Clear the all parameters
clearAllParameters();
%Populate the new one
paramNr=1;
top_ypos=170;
label_xpos=1;
box_xpos=205;
allowed_types=get(handles.operation_type_popupmenu,'String');
chosen_type=class(markerObj);
[truefalse, index] = ismember(chosen_type, allowed_types);
if(truefalse)
    set(handles.operation_type_popupmenu,'Value',index);
end
for i=1:length(propertyList)
    %if(strcmpi(propertyList{i},'description'))
    if (~isa(markerObj.(propertyList{i}),'Parameter'))
        continue;
    end
    property=markerObj.get(propertyList{i});
    propertyName= markerObj.get(propertyList{i}).name;
    propertyAllowedValues= markerObj.get(propertyList{i}).allowed_values;
    
    shapeHandles.parametersLabel{paramNr}= uicontrol(...
        'Parent', handles.mainPanel, 'Style', 'text',...
        'String', propertyName, 'Units', 'pixel',...
        'HorizontalAlignment','right',...
        'Position', [label_xpos top_ypos-(paramNr*30) 200 20], ...
        'FontWeight', 'normal',...
        'TooltipString', markerObj.get(propertyList{i}).description);
    
    %If the property is a number, use edit ui
    if(property.type==SimuCell_Class_Type.number)
        shapeHandles.parametersField{paramNr}= uicontrol(...
            'Parent', handles.mainPanel, 'Style', 'edit',...
            'String', property.value, 'Units', 'pixel',...
            'HorizontalAlignment','left',...
            'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
            'FontWeight', 'normal',...
            'TooltipString', markerObj.get(propertyList{i}).description);
        
        
        %If the property is a list, use list ui
    elseif(property.type==SimuCell_Class_Type.list)
        
        [is_value_inlist, index] = ismember(property.value, propertyAllowedValues);
        
        shapeHandles.parametersField{paramNr}= uicontrol(...
            'Parent', handles.mainPanel, 'Style', 'popupmenu',...
            'Value',index,'String', propertyAllowedValues, 'Units', 'pixel',...
            'HorizontalAlignment','left',...
            'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
            'FontWeight', 'normal',...
            'TooltipString', markerObj.get(propertyList{i}).description);
        %If the property is a simucell_shape_model, use list ui
    elseif(property.type==SimuCell_Class_Type.simucell_shape_model)
        objectList=properties(shapeHandles.subpop.objects);
        if(isempty(objectList))
            warndlg({['You MUST have defined a object PREVIOUSLY in order to '...
                'use this model.'],
                'Please Cancel or choose and other Type/Model.'});
            setappdata(0,'shapeHandles',shapeHandles);
            handles=clearAllParameters();
            %       shapeHandles=getappdata(0,'shapeHandles');
            %       setappdata(0,'shapeHandles',shapeHandles);
            %guidata(hObject, handles);
            return;
        else
            %objectNameList=fieldnames(shapeHandles.objects);
            
            shapeHandles.parametersField{paramNr}= uicontrol(...
                'Parent', handles.mainPanel, 'Style', 'popupmenu',...
                'String', objectList, 'Units', 'pixel',...
                'HorizontalAlignment','left',...
                'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
                'FontWeight', 'normal',...
                'TooltipString', markerObj.get(propertyList{i}).description);
            name=shapeHandles.subpop.find_shape_name(property.value);
            if(~isempty(name))
                set(shapeHandles.parametersField{paramNr},'Value',find(strcmp(objectNameList, name)));
            end
        end
    elseif(property.type==SimuCell_Class_Type.simucell_marker_model)
        marker_list=cell(0);
        markers=properties(shapeHandles.subpop.markers);
        counter=1;
        for marker_num=1:length(markers)
            objects=properties(shapeHandles.subpop.markers.(markers{marker_num}));
            for object_num=1:length(objects)
                if(isa(shapeHandles.subpop.markers.(markers{marker_num}).(objects{object_num}),...
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
            setappdata(0,'shapeHandles',shapeHandles);
            handles=clearAllParameters();
            %       shapeHandles=getappdata(0,'shapeHandles');
            %       setappdata(0,'shapeHandles',shapeHandles);
            %guidata(hObject, handles);
            return;
        else
            
            shapeHandles.parametersField{paramNr}= uicontrol(...
                'Parent', handles.mainPanel, 'Style', 'popupmenu',...
                'String', marker_list, 'Units', 'pixel',...
                'HorizontalAlignment','left',...
                'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
                'FontWeight', 'normal',...
                'TooltipString', markerObj.get(propertyList{i}).description);
            if(property.value~=0)
                [marker_name,shape_name]=shapeHandles.subpop.find_marker_name(property.value);
                if(~isempty(marker_name))
                    set(shapeHandles.parametersField{paramNr},'Value',find(strcmp(objectNameList, [marker_name '>' shape_name])));
                end
            end
        end
        
        
        
    end
    paramNr=paramNr+1;
end
% Update handles structure
setappdata(0,'shapeHandles',shapeHandles);
guidata(hObject, handles);


%Remove all previous Model parameters
function handles=clearAllParameters()
%Clear the all parameters

shapeHandles=getappdata(0,'shapeHandles');
if isfield(shapeHandles,'parametersLabel')
    for i=1:length(shapeHandles.parametersLabel)
        if(ishandle(shapeHandles.parametersLabel{i}))
            delete(shapeHandles.parametersLabel{i});
        end
    end
    handles=rmfield(shapeHandles,'parametersLabel');
end
if isfield(shapeHandles,'parametersField')
    for i=1:length(shapeHandles.parametersField)
        if(ishandle(shapeHandles.parametersField{i}))
            delete(shapeHandles.parametersField{i});
        end
    end
    handles=rmfield(shapeHandles,'parametersField');
    setappdata(0,'shapeHandles',shapeHandles);
end


% --- Executes on selection change in operation_type_popupmenu.
function operation_type_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to operation_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


shapeHandles=getappdata(0,'shapeHandles');
%Get the description of the first selected Model
selectedString=get(handles.operation_type_popupmenu,'String');
selectedValue=get(handles.operation_type_popupmenu,'Value');
%shapeObj=shapeHandles.temp_operation_queue.operations{selectedValue};
shapeObj=eval(selectedString{selectedValue});
set(handles.descriptionText,'String',shapeObj.description);
setParametersPanel(hObject,handles,shapeObj);
guidata(hObject, handles);
% Hints: contents = cellstr(get(hObject,'String')) returns operation_type_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from operation_type_popupmenu


% --- Executes during object creation, after setting all properties.
function operation_type_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operation_type_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DoneButton.
function DoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to DoneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

shapeHandles=getappdata(0,'shapeHandles');

shapeHandles.markerProperty=shapeHandles.temp_operation_queue;
setappdata(0,'shapeHandles',shapeHandles);
uiresume(handles.figure1);
