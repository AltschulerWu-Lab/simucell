function varargout = define_cell_placement(varargin)
% DEFINE_CELL_PLACEMENT MATLAB code for define_cell_placement.fig
%      DEFINE_CELL_PLACEMENT, by itself, creates a new DEFINE_CELL_PLACEMENT or raises the existing
%      singleton*.
%
%      H = DEFINE_CELL_PLACEMENT returns the handle to a new DEFINE_CELL_PLACEMENT or the handle to
%      the existing singleton*.
%
%      DEFINE_CELL_PLACEMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_CELL_PLACEMENT.M with the given input arguments.
%
%      DEFINE_CELL_PLACEMENT('Property','Value',...) creates a new DEFINE_CELL_PLACEMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_cell_placement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_cell_placement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_cell_placement

% Last Modified by GUIDE v2.5 10-Feb-2012 12:01:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_cell_placement_OpeningFcn, ...
                   'gui_OutputFcn',  @define_cell_placement_OutputFcn, ...
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


% --- Executes just before define_cell_placement is made visible.
function define_cell_placement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_cell_placement (see VARARGIN)

% Choose default command line output for define_cell_placement
handles.output = hObject;
if (length(varargin) < 2) %|| ~isa(varargin{1}, 'importantObjectType')
     error ('you must pass your simucell_data and subpopulation nr');
end
cellPlacementHandles.subpopulations=varargin{1};
subpop_nr =  varargin{2};
nrOfSubpoulation=length(cellPlacementHandles.subpopulations);
cellPlacementHandles.temp_placement_list=cell(nrOfSubpoulation,1);
cellPlacementHandles.placement_list=cell(nrOfSubpoulation,1);
for i=1:length(cellPlacementHandles.subpopulations)
  cellPlacementHandles.temp_placement_list{i}=cellPlacementHandles.subpopulations{i}.placement;
  cellPlacementHandles.placement_list{i}=cellPlacementHandles.subpopulations{i}.placement;
end

setappdata(0,'cellPlacementHandles',cellPlacementHandles);

%Populate the subpopulation Combo Box
subpopNr=length(cellPlacementHandles.subpopulations);
set(handles.subpopNrCB,'String',num2cell(1:subpopNr),'Value',subpop_nr);
%Populate the Placement ComboBox list (just once)
fileList=dir('plugins/placement/*.m');
fileList = {fileList(find([fileList.isdir]==0)).name};
for i=1:length(fileList)
  fileList{i}=fileList{i}(1:end-2);
end
set(handles.placementCB,'String',fileList);
%Set the Cell placement type for the selected subpopulation
populateCellPlacementType(subpop_nr,handles);

placementCB_Callback(handles.placementCB, [], handles);

guidata(hObject, handles);
%Wait until GUI get close 
uiwait(handles.figure1);


function populateCellPlacementType(subpopNr,handles)
%Next 2 lines need to be done only once
fileList=dir('plugins/placement/');
fileList = {fileList(find([fileList.isdir]==0)).name};
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
%Get the selected SubpopNr
currentSubPopNr=get(handles.subpopNrCB,'Value');
%Get the placement for this subpopulation
currentPlacement=cellPlacementHandles.temp_placement_list{currentSubPopNr};
%Set the Cell placement type for the selected subpopulation
if(~isempty(currentPlacement));
  currentClassName=class(currentPlacement);
  selectedPlacement=currentClassName;
  if(~isempty(selectedPlacement))
     valueSelected=find(strcmp(fileList, [selectedPlacement '.m']));
     %Set the Placement Type
     set(handles.placementCB,'Value',valueSelected);
  end
end

% --- Outputs from this function are returned to the command line.
function varargout = define_cell_placement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
varargout{1}=cellPlacementHandles.subpopulations;
if(~isempty(handles))
  delete(handles.figure1);
end


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);

% --- Executes on button press in backButton.
function backButton_Callback(hObject, eventdata, handles)
% hObject    handle to backButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
%Replace all the placement in subpopulations
for i=1:length(cellPlacementHandles.subpopulations)
  cellPlacementHandles.subpopulations{i}.placement=cellPlacementHandles.temp_placement_list{i};
end
setappdata(0,'cellPlacementHandles',cellPlacementHandles);
uiresume(handles.figure1);



% --- Executes on selection change in placementCB.
function placementCB_Callback(hObject, eventdata, handles)
% hObject    handle to placementCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns placementCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from placementCB
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
currentSubPopNr=get(handles.subpopNrCB,'Value');
currentPlacementObj=cellPlacementHandles.temp_placement_list{currentSubPopNr};
selectedString=get(handles.placementCB,'String');
selectedValue=get(handles.placementCB,'Value');
placementObj=eval(selectedString{selectedValue});
if(strcmp(class(placementObj),class(currentPlacementObj)))
  placementObj=currentPlacementObj;
end
%set(handles.descriptionText,'String',placementObj.description);
setParametersPanel(hObject,handles,placementObj);
guidata(hObject, handles);






% --- Executes during object creation, after setting all properties.
function placementCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to placementCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%TODO: USE THE GENERIC FUNCTION saveObjectFromParameters INSTEAD
% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
%Get the Object Type
selectedString=get(handles.placementCB,'String');
selectedValue=get(handles.placementCB,'Value');
%Create new Shape Model Object
placementObj=eval(selectedString{selectedValue});
%Get the property setted for this new object
propertyList = properties(placementObj);
paramNr=1;
for i=1:length(propertyList)
    if (~isa(placementObj.(propertyList{i}),'Parameter'))
        continue;
    end
    if(placementObj.(propertyList{i}).type==SimuCell_Class_Type.number)
        propertyValue=get(cellPlacementHandles.parametersField{paramNr},'String');
        try
            propertyValue=str2double(propertyValue);
        catch
            ;
        end
    elseif(placementObj.(propertyList{i}).type==SimuCell_Class_Type.list)
        propertyValue=get(cellPlacementHandles.parametersField{i},'String');
        propertyIndex=get(cellPlacementHandles.parametersField{i},'Value');
        
        propertyValue=propertyValue{propertyIndex};
    elseif(placementObj.(propertyList{i}).type==SimuCell_Class_Type.simucell_shape_model)
        propertyValue=get(cellPlacementHandles.parametersField{i},'String');
        propertyIndex=get(cellPlacementHandles.parametersField{i},'Value');
        
        propertyValue=cellPlacementHandles.subpop.objects.(propertyValue{propertyIndex});
        
    elseif(placementObj.(propertyList{i}).type==SimuCell_Class_Type.simucell_marker_model)
        propertyValue=get(cellPlacementHandles.parametersField{i},'String');
        propertyIndex=get(cellPlacementHandles.parametersField{i},'Value');
        split_vals=regexpi(propertyValue{propertyIndex},'>','split');
        
        propertyValue=cellPlacementHandles.subpop.markers.(split_vals{1}).(split_vals{2});
    end
    %Set the value to the corresponding parameter
    set(placementObj,propertyList{i},propertyValue);
    paramNr=paramNr+1;
end
%Save the created Object
%Get the selected SubpopNr
currentSubPopNr=get(handles.subpopNrCB,'Value');
%Create a new Placement Type Object
cellPlacementHandles.temp_placement_list{currentSubPopNr}=placementObj;
%Set the Cell placement type for the selected subpopulation
%populateCellPlacementType(subpop_nr,handles);
guidata(hObject, handles);
setappdata(0,'cellPlacementHandles',cellPlacementHandles);


% --- Executes on selection change in subpopNrCB.
function subpopNrCB_Callback(hObject, eventdata, handles)
% hObject    handle to subpopNrCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subpopNrCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subpopNrCB
subpop_nr=get(handles.subpopNrCB,'Value');
%Set the Cell placement type for the selected subpopulation
populateCellPlacementType(subpop_nr,handles);
placementCB_Callback(handles.placementCB, [], handles);


% --- Executes during object creation, after setting all properties.
function subpopNrCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subpopNrCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%TODO USE THE GENERIC setParametersPanel function INSTEAD
function setParametersPanel(hObject,handles,placementObj)
propertyList = properties(placementObj);
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
%Clear the all parameters
clearAllParameters();
%Populate the new one
paramNr=1;
top_ypos=420;
label_xpos=1;
box_xpos=240;
for i=1:length(propertyList)
    if (~isa(placementObj.(propertyList{i}),'Parameter'))
        continue;
    end
    property=placementObj.get(propertyList{i});
    propertyName= placementObj.get(propertyList{i}).name;
    propertyAllowedValues= placementObj.get(propertyList{i}).allowed_values;
    
    cellPlacementHandles.parametersLabel{paramNr}= uicontrol(...
        'Parent', handles.mainPanel, 'Style', 'text',...
        'String', propertyName, 'Units', 'pixel',...
        'HorizontalAlignment','right',...
        'Position', [label_xpos top_ypos-(paramNr*30) 235 20], ...
        'FontWeight', 'normal',...
        'TooltipString', placementObj.get(propertyList{i}).description);
    
    %If the property is a number, use edit ui
    if(property.type==SimuCell_Class_Type.number)
        cellPlacementHandles.parametersField{paramNr}= uicontrol(...
            'Parent', handles.mainPanel, 'Style', 'edit',...
            'String', property.value, 'Units', 'pixel',...
            'HorizontalAlignment','left',...
            'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
            'FontWeight', 'normal',...
            'TooltipString', placementObj.get(propertyList{i}).description);
        
        %If the property is a list, use list ui
    elseif(property.type==SimuCell_Class_Type.list)
        
        [is_value_inlist, index] = ismember(property.value, propertyAllowedValues);
        
        cellPlacementHandles.parametersField{paramNr}= uicontrol(...
            'Parent', handles.mainPanel, 'Style', 'popupmenu',...
            'Value',index,'String', propertyAllowedValues, 'Units', 'pixel',...
            'HorizontalAlignment','left',...
            'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
            'FontWeight', 'normal',...
            'TooltipString', placementObj.get(propertyList{i}).description);
        %If the property is a simucell_shape_model, use list ui
    elseif(property.type==SimuCell_Class_Type.simucell_shape_model)
        objectList=properties(cellPlacementHandles.subpop.objects);
        if(isempty(objectList))
            warndlg({['You MUST have defined a object PREVIOUSLY in order to '...
                'use this model.'],
                'Please Cancel or choose and other Type/Model.'});
            setappdata(0,'cellPlacementHandles',cellPlacementHandles);
            handles=clearAllParameters();
            return;
        else
            %objectNameList=fieldnames(cellPlacementHandles.objects);
            
            cellPlacementHandles.parametersField{paramNr}= uicontrol(...
                'Parent', handles.mainPanel, 'Style', 'popupmenu',...
                'String', objectList, 'Units', 'pixel',...
                'HorizontalAlignment','left',...
                'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
                'FontWeight', 'normal',...
                'TooltipString', placementObj.get(propertyList{i}).description);
            if(property.value~=0)
                name=cellPlacementHandles.subpop.find_shape_name(property.value);
                if(~isempty(name))
                    set(cellPlacementHandles.parametersField{paramNr},'Value',find(strcmp(objectList, name)));
                end
            end
        end
    elseif(property.type==SimuCell_Class_Type.simucell_marker_model)
        marker_list=cell(0);
        markers=properties(cellPlacementHandles.subpop.markers);
        counter=1;
        for marker_num=1:length(markers)
            objects=properties(cellPlacementHandles.subpop.markers.(markers{marker_num}));
            for object_num=1:length(objects)
                if(isa(cellPlacementHandles.subpop.markers.(markers{marker_num}).(objects{object_num}),...
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
            setappdata(0,'cellPlacementHandles',cellPlacementHandles);
            handles=clearAllParameters();
            return;
        else
            
            cellPlacementHandles.parametersField{paramNr}= uicontrol(...
                'Parent', handles.mainPanel, 'Style', 'popupmenu',...
                'String', marker_list, 'Units', 'pixel',...
                'HorizontalAlignment','left',...
                'Position', [box_xpos top_ypos-(paramNr*30) 200 20], ...
                'FontWeight', 'normal',...
                'TooltipString', placementObj.get(propertyList{i}).description);
            if(property.value~=0)
                [marker_name,shape_name]=cellPlacementHandles.subpop.find_marker_name(property.value);
                if(~isempty(marker_name))
                    set(cellPlacementHandles.parametersField{paramNr},'Value',find(strcmp(marker_list, [marker_name '>' shape_name])));
                end
            end
        end
    end
    paramNr=paramNr+1;
end
% Update handles structure
setappdata(0,'cellPlacementHandles',cellPlacementHandles);
guidata(hObject, handles);


%Remove all previous Model parameters
function handles=clearAllParameters()
%Clear the all parameters
cellPlacementHandles=getappdata(0,'cellPlacementHandles');
if isfield(cellPlacementHandles,'parametersLabel')
    for i=1:length(cellPlacementHandles.parametersLabel)
        if(ishandle(cellPlacementHandles.parametersLabel{i}))
            delete(cellPlacementHandles.parametersLabel{i});
        end
    end
    handles=rmfield(cellPlacementHandles,'parametersLabel');
end
if isfield(cellPlacementHandles,'parametersField')
    for i=1:length(cellPlacementHandles.parametersField)
        if(ishandle(cellPlacementHandles.parametersField{i}))
            delete(cellPlacementHandles.parametersField{i});
        end
    end
    handles=rmfield(cellPlacementHandles,'parametersField');
    setappdata(0,'cellPlacementHandles',cellPlacementHandles);
end
