function varargout = define_compositing(varargin)
% DEFINE_COMPOSITING MATLAB code for define_compositing.fig
%      DEFINE_COMPOSITING, by itself, creates a new DEFINE_COMPOSITING or raises the existing
%      singleton*.
%
%      H = DEFINE_COMPOSITING returns the handle to a new DEFINE_COMPOSITING or the handle to
%      the existing singleton*.
%
%      DEFINE_COMPOSITING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_COMPOSITING.M with the given input arguments.
%
%      DEFINE_COMPOSITING('Property','Value',...) creates a new DEFINE_COMPOSITING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_compositing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_compositing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_compositing

% Last Modified by GUIDE v2.5 08-Mar-2012 15:16:57

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
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_compositing_OpeningFcn, ...
                   'gui_OutputFcn',  @define_compositing_OutputFcn, ...
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


% --- Executes just before define_compositing is made visible.
function define_compositing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_compositing (see VARARGIN)
handles.output = hObject;
if (length(varargin) < 2) %|| ~isa(varargin{1}, 'importantObjectType')
     error ('You must pass your simucell_data and subpopulation nr');
end
compositingHandles.subpopulations=varargin{1};
subpop_nr =  varargin{2};
nrOfSubpoulation=length(compositingHandles.subpopulations);
compositingHandles.temp_compositing_list=cell(nrOfSubpoulation,1);
compositingHandles.compositing_list=cell(nrOfSubpoulation,1);
for i=1:length(compositingHandles.subpopulations)
  compositingHandles.temp_compositing_list{i}=compositingHandles.subpopulations{i}.compositing;
  compositingHandles.compositing_list{i}=compositingHandles.subpopulations{i}.compositing;
end

setappdata(0,'compositingHandles',compositingHandles);

%Populate the subpopulation Combo Box
subpopNr=length(compositingHandles.subpopulations);
set(handles.subpopNrCB,'String',num2cell(1:subpopNr),'Value',subpop_nr);
%Populate the Composite ComboBox list (just once)
fileList=dir(['plugins' filesep 'composite' filesep '*.m']);
fileList = {fileList(find([fileList.isdir]==0)).name};
for i=1:length(fileList)
  fileList{i}=fileList{i}(1:end-2);
end
set(handles.compositingCB,'String',fileList);
%Set the Compositing type for the selected subpopulation
populatecompositingType(subpop_nr,handles);

compositingCB_Callback(handles.compositingCB, [], handles);

guidata(hObject, handles);
%Wait until GUI get close 
uiwait(handles.figure1);


function populatecompositingType(subpopNr,handles)
%Next 2 lines need to be done only once
fileList=dir(['plugins' filesep 'composite' filesep '*.m']);
fileList = {fileList(find([fileList.isdir]==0)).name};
compositingHandles=getappdata(0,'compositingHandles');
%Get the selected SubpopNr
currentSubPopNr=get(handles.subpopNrCB,'Value');
%Get the compositing for this subpopulation
currentcompositing=compositingHandles.temp_compositing_list{currentSubPopNr};
%Set the Cell compositing type for the selected subpopulation
if(~isempty(currentcompositing));
  currentClassName=class(currentcompositing);
  selectedcompositing=currentClassName;
  if(~isempty(selectedcompositing))
     valueSelected=find(strcmp(fileList, [selectedcompositing '.m']));
     %Set the compositing Type
     set(handles.compositingCB,'Value',valueSelected);
  end
end

% --- Outputs from this function are returned to the command line.
function varargout = define_compositing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
compositingHandles=getappdata(0,'compositingHandles');
varargout{1}=compositingHandles.subpopulations;
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
compositingHandles=getappdata(0,'compositingHandles');
%Replace all the compositing in subpopulations
for i=1:length(compositingHandles.subpopulations)
  compositingHandles.subpopulations{i}.compositing=compositingHandles.temp_compositing_list{i};
end
setappdata(0,'compositingHandles',compositingHandles);
uiresume(handles.figure1);

% --- Executes on selection change in compositingCB.
function compositingCB_Callback(hObject, eventdata, handles)
% hObject    handle to compositingCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
compositingHandles=getappdata(0,'compositingHandles');
currentSubPopNr=get(handles.subpopNrCB,'Value');
currentCompositingObj=compositingHandles.temp_compositing_list{currentSubPopNr};
selectedString=get(handles.compositingCB,'String');
selectedValue=get(handles.compositingCB,'Value');
compositingObj=eval(selectedString{selectedValue});
if(strcmp(class(compositingObj),class(currentCompositingObj)))
  compositingObj=currentCompositingObj;
end
compositingHandles=getappdata(0,'compositingHandles');
  setCompositingParametersPanel(hObject,handles,...
    compositingObj,compositingHandles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function compositingCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to compositingCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
compositingHandles=getappdata(0,'compositingHandles');
%Get the Object Type
selectedString=get(handles.compositingCB,'String');
selectedValue=get(handles.compositingCB,'Value');
%Create new Compositing Object
compositingObj=eval(selectedString{selectedValue});
compositingObj=saveObjectFromParameters(compositingObj,compositingHandles.parametersField,...
  compositingHandles.subpopulations);
currentSubPopNr=get(handles.subpopNrCB,'Value');
%Save the created Object
compositingHandles.temp_compositing_list{currentSubPopNr}=compositingObj;
% compositingHandles.compositingObj=compositingObj;
guidata(hObject, handles);
setappdata(0,'compositingHandles',compositingHandles);


% --- Executes on selection change in subpopNrCB.
function subpopNrCB_Callback(hObject, eventdata, handles)
% hObject    handle to subpopNrCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
subpop_nr=get(handles.subpopNrCB,'Value');
%Set the Cell placement type for the selected subpopulation
populatecompositingType(subpop_nr,handles);
compositingCB_Callback(handles.compositingCB, [], handles);


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


function setCompositingParametersPanel(hObject,handles,operationObj,compositingHandles)
objectDescriptionHandle=handles.descriptionText;
handleName='compositingHandles';
allowed_types=get(handles.compositingCB,'String');
operationTypePopupMenu=handles.compositingCB;
compositingHandles.parametersLabel=[];
compositingHandles.parametersField=[];
parametersLabelList=compositingHandles.parametersLabel;
parametersFieldList=compositingHandles.parametersField;
parentPanel=handles.mainPanel;
subpopulation=compositingHandles.subpopulations;
%Bottom:290px
[parametersLabelList,parametersFieldList]=setParametersPanel(hObject,handles,...
  operationObj,objectDescriptionHandle,handleName,...
  @clearAllParameters,...
  allowed_types,operationTypePopupMenu,parametersLabelList,...
  parametersFieldList,parentPanel,subpopulation);
compositingHandles.parametersLabel=parametersLabelList;
compositingHandles.parametersField=parametersFieldList;
setappdata(0,'compositingHandles',compositingHandles);


%Remove all previous Compositing parameters
function handles=clearAllParameters()
%Clear the all parameters
compositingHandles=getappdata(0,'compositingHandles');
if isfield(compositingHandles,'parametersLabel')
  for i=1:length(compositingHandles.parametersLabel)
    if(ishandle(compositingHandles.parametersLabel{i}))
      delete(compositingHandles.parametersLabel{i});
    end
  end
handles=rmfield(compositingHandles,'parametersLabel');
end
if isfield(compositingHandles,'parametersField')
  for i=1:length(compositingHandles.parametersField)
    if(ishandle(compositingHandles.parametersField{i}))
      delete(compositingHandles.parametersField{i});
    end
  end
handles=rmfield(compositingHandles,'parametersField');
setappdata(0,'compositingHandles',compositingHandles);
end
