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

if (length(varargin) < 5) %|| ~isa(varargin{1}, 'importantObjectType')
     error ('you must pass your object name and subpopulation nr');
end
shapeHandles.object_name = varargin{1};
shapeHandles.subpop_nr = varargin{2};
shapeHandles.objects=varargin{3};
shapeHandles.currentObject=varargin{4};
shapeHandles.subpop=varargin{5};
set(handles.title,'String',['Define your object '...
  ' for subpopulation ' num2str(shapeHandles.subpop_nr)]);

shapeHandles.selectedType=[];
shapeHandles.selectedModel=[];
if(~isempty(shapeHandles.currentObject.model))
  currentClassName=class(shapeHandles.currentObject.model);
  shapeListFile=getAllFiles('plugins/shape/');
  shapeListFile = strrep(shapeListFile, 'plugins/shape/', '');
  result=cellfun(@(x)regexp(x,[currentClassName '.m']),shapeListFile,...
    'UniformOutput',false);
  shapeHandles.selectedType=shapeListFile{cellfun(@(y)~isempty(y),result)};
  r=regexp(shapeHandles.selectedType,'/','split');
  shapeHandles.selectedType=r{1};
  shapeHandles.selectedModel=currentClassName;
end
setappdata(0,'shapeHandles',shapeHandles);


%Populate the Type ComboBox
dirList=dir('plugins/shape/');
dirList = {dirList(find([dirList.isdir])).name};
dirList=dirList(3:end);
if(~isempty(shapeHandles.selectedType))
  valueSelected=find(strcmp(dirList, shapeHandles.selectedType));
  %Set the shape Type
  set(handles.shapeTypeCb,'String',dirList,'Value',valueSelected);
  %Set the shape Model
  guidata(hObject, handles);
  shapeTypeCb_Callback(hObject, eventdata, handles);
  modelList=get(handles.shapeModelCb,'String');
  
  valueSelected=find(strcmp(modelList, shapeHandles.selectedModel));
  set(handles.shapeModelCb,'Value',valueSelected);
  %Set the parameters field  
  shapeHandles=getappdata(0,'shapeHandles');
  setShapeParametersPanel(hObject,handles,...
    shapeHandles.currentObject.model,shapeHandles);
  %setParametersPanel(hObject,handles,shapeHandles.currentObject.model);  
else
  set(handles.shapeTypeCb,'String',dirList);
end
set(handles.nameEdit,'String',shapeHandles.object_name);


if(isempty(shapeHandles.selectedType))
  shapeTypeCb_Callback(hObject, eventdata, handles);
end
% UIWAIT makes define_shape wait for user response (see UIRESUME)
% uiwait(handles.figure1);
uiwait(handles.figure1);
%delete(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_shape_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;
shapeHandles=getappdata(0,'shapeHandles');
if(isfield(shapeHandles,'shapeObj'))
  varargout{1}=shapeHandles.shapeObj;
else
  varargout{1}=[];
end
varargout{2}=shapeHandles.object_name;
if(~isempty(handles))
  delete(handles.figure1);
end

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
fileList=dir(['plugins/shape/' selectedString{selectedValue} '/*.m']);
fileList = {fileList(find([fileList.isdir]==0)).name};
for i=1:length(fileList)
  fileList{i}=fileList{i}(1:end-2);
end
set(handles.shapeModelCb,'String',fileList);
shapeModelCb_Callback(hObject, eventdata, handles);


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
shapeHandles=getappdata(0,'shapeHandles');
setShapeParametersPanel(hObject,handles,shapeObj,shapeHandles);


function setShapeParametersPanel(hObject,handles,operationObj,shapeHandles)
objectDescriptionHandle=handles.descriptionText;
handleName='shapeHandles';
allowed_types=get(     handles.shapeModelCb,'String');
operationTypePopupMenu=handles.shapeModelCb;
shapeHandles.parametersLabel=[];
shapeHandles.parametersField=[];
parametersLabelList=shapeHandles.parametersLabel;
parametersFieldList=shapeHandles.parametersField;
parentPanel=handles.mainPanel;
subpopulation=shapeHandles.subpop;
%Bottom:290px
[parametersLabelList,parametersFieldList]=setParametersPanel(hObject,handles,...
  operationObj,objectDescriptionHandle,handleName,...
  @clearAllParameters,...
  allowed_types,operationTypePopupMenu,parametersLabelList,...
  parametersFieldList,parentPanel,subpopulation);
shapeHandles.parametersLabel=parametersLabelList;
shapeHandles.parametersField=parametersFieldList;
setappdata(0,'shapeHandles',shapeHandles);


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


%Return the cell list of Object of the current subpopulation minux the one
%that we try to define (Used for Object depending on other object).
function objectList2=getOtherObjectList(handles)
shapeHandles=getappdata(0,'shapeHandles');
objectList=fieldnames(shapeHandles.objects);
objectList2=cell(0);
counter=1;
for i=1:length(objectList)
  if(~strcmpi(objectList{i},shapeHandles.object_name))
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
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shapeHandles=getappdata(0,'shapeHandles');
%Get the Object Type
selectedString=get(handles.shapeModelCb,'String');
selectedValue=get(handles.shapeModelCb,'Value');
%Create new Shape Model Object
shapeObj=eval(selectedString{selectedValue});
shapeObj=saveObjectFromParameters(shapeObj,shapeHandles.parametersField,...
  shapeHandles.subpop);
%Save the created Object
shapeHandles.shapeObj.model=shapeObj;
guidata(hObject, handles);
%close(handles.figure1);
setappdata(0,'shapeHandles',shapeHandles);
uiresume;


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
shapeHandles=getappdata(0,'shapeHandles');
shapeHandles.shapeObj=[];
setappdata(0,'shapeHandles',shapeHandles);
uiresume;
