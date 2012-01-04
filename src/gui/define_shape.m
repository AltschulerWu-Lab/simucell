function varargout = define_shape(varargin)
% DEFINE_SHAPE MATLAB code for define_shape.fig
%      DEFINE_SHAPE, by itself, creates a new DEFINE_SHAPE or raises the existing
%      singleton*.
%
%      H = DEFINE_SHAPE returns the handle to a new DEFINE_SHAPE or the handle to
%      the existing singleton*.
%
%      DEFINE_SHAPE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_SHAPE.M with the given input arguments.
%
%      DEFINE_SHAPE('Property','Value',...) creates a new DEFINE_SHAPE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_shape_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_shape_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_shape

% Last Modified by GUIDE v2.5 03-Jan-2012 14:01:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_shape_OpeningFcn, ...
                   'gui_OutputFcn',  @define_shape_OutputFcn, ...
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


% --- Executes just before define_shape is made visible.
function define_shape_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_shape (see VARARGIN)

% Choose default command line output for define_shape
handles.output = hObject;

%Change the Title
if (length(varargin) < 3) %|| ~isa(varargin{1}, 'importantObjectType')
     error ('you must pass your object name and subpopulation nr');
end
handles.object_name = varargin{1};
handles.subpop_nr = varargin{2};
handles.objects=varargin{3};
handles.currentObject=varargin{4};
handles.subpop=varargin{5};
set(handles.title,'String',['Define your object '...
  ' for subpopulation ' num2str(handles.subpop_nr)]);


handles.selectedType=[];
handles.selectedModel=[];
if(~isempty(handles.currentObject))
  currentClassName=class(handles.currentObject);
  shapeListFile=getAllFiles('plugins/shape/');
  shapeListFile = strrep(shapeListFile, 'plugins/shape/', '');
  result=cellfun(@(x)regexp(x,[currentClassName '.m']),shapeListFile,...
    'UniformOutput',false);
  handles.selectedType=shapeListFile{cellfun(@(y)~isempty(y),result)};
  r=regexp(handles.selectedType,'/','split');
  handles.selectedType=r{1};
  handles.selectedModel=currentClassName;
end



%Populate the Type ComboBox
dirList=dir('plugins/shape/');
dirList = {dirList(find([dirList.isdir])).name};
dirList=dirList(3:end);
if(~isempty(handles.selectedType))
  valueSelected=find(strcmp(dirList, handles.selectedType));
  %Set the shape Type
  set(handles.shapeTypeCb,'String',dirList,'Value',valueSelected);
  %Set the shape Model
  guidata(hObject, handles);
  shapeTypeCb_Callback(hObject, eventdata, handles);
  modelList=get(handles.shapeModelCb,'String');
  valueSelected=find(strcmp(modelList, handles.selectedModel));
  set(handles.shapeModelCb,'Value',valueSelected);
  guidata(hObject, handles);
  %Set the parameters field
  setParametersPanel(hObject,handles,handles.currentObject);
  
else
  set(handles.shapeTypeCb,'String',dirList);
end
set(handles.nameEdit,'String',handles.object_name);


% Update handles structure
guidata(hObject, handles);
if(isempty(handles.selectedType))
  shapeTypeCb_Callback(hObject, eventdata, handles);
end
% UIWAIT makes define_shape wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_shape_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in shapeTypeCb.
function shapeTypeCb_Callback(hObject, eventdata, handles)
% hObject    handle to shapeTypeCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns shapeTypeCb contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shapeTypeCb
%Populate the Model ComboBox on fly
selectedString=get(handles.shapeTypeCb,'String');
selectedValue=get(handles.shapeTypeCb,'Value');

fileList=dir(['plugins/shape/' selectedString{selectedValue}]);
fileList = {fileList(find([fileList.isdir]==0)).name};

for i=1:length(fileList)
  fileList{i}=fileList{i}(1:end-2);
end
set(handles.shapeModelCb,'String',fileList);
shapeModelCb_Callback(hObject, eventdata, handles);

% selectedString=get(handles.shapeModelCb,'String');
% selectedValue=get(handles.shapeModelCb,'Value');


% --- Executes during object creation, after setting all properties.
function shapeTypeCb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shapeTypeCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in shapeModelCb.
function shapeModelCb_Callback(hObject, eventdata, handles)
% hObject    handle to shapeModelCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns shapeModelCb contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shapeModelCb

%Get the description of the first selected Model
selectedString=get(handles.shapeModelCb,'String');
selectedValue=get(handles.shapeModelCb,'Value');
shapeObj=eval(selectedString{selectedValue});
set(handles.descriptionText,'String',shapeObj.description);
setParametersPanel(hObject,handles,shapeObj);


function setParametersPanel(hObject,handles,shapeObj)
propertyList = fieldnames(get(shapeObj));

%Clear the all parameters
handles=clearAllParameters(handles);
%Populate the new one
paramNr=1;
for i=1:length(propertyList)
  if(strcmpi(propertyList{i},'description'))
    continue;
  end
  property=shapeObj.get(propertyList{i});
  propertyName= shapeObj.get(propertyList{i}).name;
  
  handles.parametersLabel{paramNr}= uicontrol(...
    'Parent', handles.mainPanel, 'Style', 'text',...
    'String', propertyName, 'Units', 'pixel',...
    'HorizontalAlignment','right',...
    'Position', [1 290-(paramNr*30) 200 20], ...
    'FontWeight', 'normal',...
    'TooltipString', shapeObj.get(propertyList{i}).description);  
  
  %If the property is a number, use edit ui
  if(property.type==SimuCell_Class_Type.number)
    handles.parametersField{paramNr}= uicontrol(...
      'Parent', handles.mainPanel, 'Style', 'edit',...
      'String', property.value, 'Units', 'pixel',...
      'HorizontalAlignment','left',...
      'Position', [205 290-(paramNr*30) 200 20], ...
      'FontWeight', 'normal',...
      'TooltipString', shapeObj.get(propertyList{i}).description);
    
    
  %If the property is a list, use list ui
  elseif(property.type==SimuCell_Class_Type.list)
    ;
  %If the property is a simucell_model, use list ui
  elseif(property.type==SimuCell_Class_Type.simucell_model)
    objectList=getOtherObjectList(handles);
    if(isempty(objectList))
      warndlg({['You MUST have defined a object PREVIOUSLY in order to '...
        'use this model.'],
        'Please Cancel or choose and other Type/Model.'});
      handles=clearAllParameters(handles);
      guidata(hObject, handles);
      return;
    else
      objectNameList=fieldnames(handles.objects);
      handles.parametersField{paramNr}= uicontrol(...
        'Parent', handles.mainPanel, 'Style', 'popupmenu',...
        'String', objectList, 'Units', 'pixel',...
        'HorizontalAlignment','left',...
        'Position', [205 290-(paramNr*30) 200 20], ...
        'FontWeight', 'normal',...
        'TooltipString', shapeObj.get(propertyList{i}).description);
      name=handles.subpop.find_shape_name(property.value);
      if(~isempty(name))
        set(handles.parametersField{paramNr},'Value',find(strcmp(objectNameList, name)));
      end
    end
  end
  paramNr=paramNr+1;
end
% Update handles structure
guidata(hObject, handles);


%Remove all previous Model parameters
function handles=clearAllParameters(handles)
%Clear the all parameters
if isfield(handles,'parametersLabel')
  for i=1:length(handles.parametersLabel)
    delete(handles.parametersLabel{i});
  end
handles=rmfield(handles,'parametersLabel');
end
if isfield(handles,'parametersField')
  for i=1:length(handles.parametersField)
    delete(handles.parametersField{i});
  end
handles=rmfield(handles,'parametersField');
end


%Return the cell list of Object of the current subpopulation minux the one
%that we try to define (Used for Object depending on other object).
function objectList2=getOtherObjectList(handles)
objectList=fieldnames(handles.objects);
objectList2=cell(0);
counter=1;
for i=1:length(objectList)
  if(~strcmpi(objectList{i},handles.object_name))
    objectList2{counter}=objectList{i};
    counter=counter+1;
  end
end



% --- Executes during object creation, after setting all properties.
function shapeModelCb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shapeModelCb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to nameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameEdit as text
%        str2double(get(hObject,'String')) returns contents of nameEdit as a double


% --- Executes during object creation, after setting all properties.
function nameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Create new Shape Model Object
%get object type
selectedString=get(handles.shapeModelCb,'String');
selectedValue=get(handles.shapeModelCb,'Value');
shapeObj=eval(selectedString{selectedValue});

for i=1:length(handles.parametersField)
  label=get(handles.parametersLabel{i},'String');
  
%   gethandles.parametersField
%   handles.parametersLabel
end




% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
