function varargout = define_artifact(varargin)
% DEFINE_ARTIFACT MATLAB code for define_artifact.fig
%      DEFINE_ARTIFACT, by itself, creates a new DEFINE_ARTIFACT or raises the existing
%      singleton*.
%
%      H = DEFINE_ARTIFACT returns the handle to a new DEFINE_ARTIFACT or the handle to
%      the existing singleton*.
%
%      DEFINE_ARTIFACT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_ARTIFACT.M with the given input arguments.
%
%      DEFINE_ARTIFACT('Property','Value',...) creates a new DEFINE_ARTIFACT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_artifact_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_artifact_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_artifact

% Last Modified by GUIDE v2.5 24-Feb-2012 10:41:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_artifact_OpeningFcn, ...
                   'gui_OutputFcn',  @define_artifact_OutputFcn, ...
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


% --- Executes just before define_artifact is made visible.
function define_artifact_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_artifact (see VARARGIN)

% Choose default command line output for define_artifact
handles.output = hObject;
if (length(varargin) < 3) %|| ~isa(varargin{1}, 'importantObjectType')
     error ('you must pass your simucell_data and subpopulation nr');
end
artifactHandles.subpopulations=varargin{1};
subpop_nr =  varargin{2};
nrOfSubpoulation=length(artifactHandles.subpopulations);
%Store pre-existing Cell Artifacts
artifactHandles.temp_cell_artifact_list=cell(nrOfSubpoulation,1);
artifactHandles.cell_artifact_list=cell(nrOfSubpoulation,1);
for i=1:length(artifactHandles.subpopulations)
  artifactHandles.temp_cell_artifact_list{i}=...
    artifactHandles.subpopulations{i}.cell_artifacts;
  artifactHandles.cell_artifact_list{i}=...
    artifactHandles.subpopulations{i}.cell_artifacts;
end
%Store pre-existing Image Artifacts
artifactHandles.temp_image_artifact_list=varargin{3};
artifactHandles.image_artifact_list=varargin{3};
%Save the handle
setappdata(0,'artifactHandles',artifactHandles);
%Populate the subpopulation Combo Box
subpopNr=length(artifactHandles.subpopulations);
set(handles.subpopNrCB,'String',num2cell(1:subpopNr),'Value',subpop_nr);
%Populate the cellArtifactOperationTypePopupMenu
fileList=dir('plugins/cell_artifacts/');
fileList = {fileList(find([fileList.isdir]==0)).name};
for i=1:length(fileList)
    fileList{i}=fileList{i}(1:end-2);
end
set(handles.cellArtifactOperationTypePopupMenu,'String',fileList);
%Populate the cellArtifactOperationListbox corresponding to the selected
%subpopulation
populateCellArtifactOperationListbox(hObject,handles);
%Populate the cellArtifactOperation parameters corresponding to the selected
%operation
cellArtifactOperationObj=artifactHandles.temp_cell_artifact_list{subpop_nr}{1};
%Set the setParameterPanel function parameters
operationObj=cellArtifactOperationObj;
setCellArtifactParam(hObject,handles,operationObj,artifactHandles)
%Populate the imageArtifactOperationTypePopupMenu
fileList=dir('plugins/image_artifacts/');
fileList = {fileList(find([fileList.isdir]==0)).name};
for i=1:length(fileList)
    fileList{i}=fileList{i}(1:end-2);
end
set(handles.imageArtifactOperationTypePopupMenu,'String',fileList);
%Populate the imageArtifactOperationListbox with the pre-existing one
populateImageArtifactOperationListbox(hObject,handles);
%Populate the cellArtifactOperation parameters corresponding to the selected
%operation
imageArtifactOperationObj=artifactHandles.temp_image_artifact_list{1};
setappdata(0,'artifactHandles',artifactHandles);
setImageArtifactParam(hObject,handles,imageArtifactOperationObj,...
  artifactHandles);
% Update handles structure
guidata(hObject, handles);
%Wait until GUI get close 
uiwait(handles.figure1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Cell Artifact Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function populateCellArtifactOperationListbox(hObject,handles)
artifactHandles=getappdata(0,'artifactHandles');
subpop_nr=get(handles.subpopNrCB,'Value');
operation_names=cell(length(artifactHandles.temp_cell_artifact_list{subpop_nr}),1);
for op_number=1:length(artifactHandles.temp_cell_artifact_list{subpop_nr})
    operation_names{op_number}=...
      class(artifactHandles.temp_cell_artifact_list{subpop_nr}{op_number});
end
set(handles.cellArtifactOperationListbox,'String',operation_names);
set(handles.cellArtifactOperationListbox,'Value',1);
guidata(hObject, handles);


function setCellArtifactParam(hObject,handles,operationObj,artifactHandles)
objectDescriptionHandle=handles.cellArtifactDescription;
handleName='artifactHandles';
allowed_types=get(handles.cellArtifactOperationTypePopupMenu,'String');
operationTypePopupMenu=handles.cellArtifactOperationTypePopupMenu;
artifactHandles.cellArtifactParametersLabel=[];
artifactHandles.cellArtifactParametersField=[];
parametersLabelList=artifactHandles.cellArtifactParametersLabel;
parametersFieldList=artifactHandles.cellArtifactParametersField;
parentPanel=handles.cellArtifactPanel;
subpop_nr=get(handles.subpopNrCB,'Value');
subpopulationList=artifactHandles.subpopulations{subpop_nr};
[parametersLabelList,parametersFieldList]=setParametersPanel(hObject,handles,...
  operationObj,objectDescriptionHandle,handleName,...
  @clearCellArtifactParameters,...
  allowed_types,operationTypePopupMenu,parametersLabelList,...
  parametersFieldList,parentPanel,subpopulationList);
artifactHandles.cellArtifactParametersLabel=parametersLabelList;
artifactHandles.cellArtifactParametersField=parametersFieldList;
setappdata(0,'artifactHandles',artifactHandles);


%Remove all previous Model parameters
function handles=clearCellArtifactParameters()
%Clear the all parameters
artifactHandles=getappdata(0,'artifactHandles');
if isfield(artifactHandles,'cellArtifactParametersLabel')
    for i=1:length(artifactHandles.cellArtifactParametersLabel)
        if(ishandle(artifactHandles.cellArtifactParametersLabel{i}))
            delete(artifactHandles.cellArtifactParametersLabel{i});
        end
    end
    handles=rmfield(artifactHandles,'cellArtifactParametersLabel');
end
if isfield(artifactHandles,'cellArtifactParametersField')
    for i=1:length(artifactHandles.cellArtifactParametersField)
        if(ishandle(artifactHandles.cellArtifactParametersField{i}))
            delete(artifactHandles.cellArtifactParametersField{i});
        end
    end
    handles=rmfield(artifactHandles,'cellArtifactParametersField');
    setappdata(0,'artifactHandles',artifactHandles);
end


% --- Executes on selection change in subpopNrCB.
function subpopNrCB_Callback(hObject, eventdata, handles)
% hObject    handle to subpopNrCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
subpop_nr=get(hObject,'Value');
populateCellArtifactOperationListbox(hObject,handles);
cellArtifactOperationObj=artifactHandles.temp_cell_artifact_list{subpop_nr}{1};
%Set the setParameterPanel function parameters
operationObj=cellArtifactOperationObj;
setCellArtifactParam(hObject,handles,operationObj,artifactHandles);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function subpopNrCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subpopNrCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cellArtifactOperationTypePopupMenu.
function cellArtifactOperationTypePopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationTypePopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Get the cellArtifactObject selected
selectedValue=get(handles.cellArtifactOperationListbox,'Value');
subpop_nr=get(handles.subpopNrCB,'Value');
cellArtifactObj=artifactHandles.temp_cell_artifact_list{subpop_nr}{selectedValue};
contents = cellstr(get(hObject,'String'));
cellArtifactNameSelected=contents{get(hObject,'Value')};
cellArtifactObjSelected=eval(cellArtifactNameSelected);
setappdata(0,'artifactHandles',artifactHandles);
%Set the setParameterPanel function parameters
if(strcmp(class(cellArtifactObj),class(cellArtifactObjSelected)))
  operationObj=cellArtifactOperationObj;
else
  operationObj=cellArtifactObjSelected;
end
setCellArtifactParam(hObject,handles,operationObj,artifactHandles);


% --- Executes during object creation, after setting all properties.
function cellArtifactOperationTypePopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationTypePopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cellArtifactViewButton.
function cellArtifactViewButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactViewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cellArtifactSaveButton.
function cellArtifactSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Get the Object Type
selectedString=get(handles.cellArtifactOperationTypePopupMenu,'String');
selectedValue=get(handles.cellArtifactOperationTypePopupMenu,'Value');
%Create new Shape Model Object
artifactObj=eval(selectedString{selectedValue});
subpop_nr=get(handles.subpopNrCB,'Value');
artifactObj=saveObjectFromParameters(artifactObj,...
  artifactHandles.cellArtifactParametersField,artifactHandles.subpopulations{subpop_nr});
%Save the created Object
operation_number=get(handles.cellArtifactOperationListbox,'Value');
subpop_nr=get(handles.subpopNrCB,'Value');
artifactHandles.temp_cell_artifact_list{subpop_nr}{operation_number}=artifactObj;
%Save the handle
setappdata(0,'artifactHandles',artifactHandles);
%Repopulate the Listbox of Image Artifact Operation
populateCellArtifactOperationListbox(hObject,handles);
guidata(hObject, handles);
set(handles.cellArtifactOperationListbox,'Value',operation_number);
guidata(hObject, handles);
%Populate the cellArtifactOperation parameters corresponding to the selected
%operation
setappdata(0,'artifactHandles',artifactHandles);
%Set the setParameterPanel function parameters
operationObj=artifactObj;
setCellArtifactParam(hObject,handles,operationObj,artifactHandles);
guidata(hObject, handles);


% --- Executes on button press in cellArtifactRemoveButton.
function cellArtifactRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
subpop_nr=get(handles.subpopNrCB,'Value');
operation_to_remove=get(handles.cellArtifactOperationListbox,'Value');
artifactHandles.temp_cell_artifact_list{subpop_nr} =...
  removeFromCellArray(artifactHandles.temp_cell_artifact_list{subpop_nr},...
  operation_to_remove);
setappdata(0,'artifactHandles',artifactHandles);
populateCellArtifactOperationListbox(hObject, handles);
set(handles.cellArtifactOperationListbox,'Value',...
  max(get(handles.cellArtifactOperationListbox,'Value')-1,1));
guidata(hObject, handles);
cellArtifactOperationListbox_Callback(hObject, eventdata, handles);


% --- Executes on button press in cellArtifactAddButton.
function cellArtifactAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
subpop_nr=get(handles.subpopNrCB,'Value');
%Instantiate the first most basic cell artifact plugin: Out_Of_Focus_Cells
%TODO: Make sure it is always here...
artifactHandles.temp_cell_artifact_list{subpop_nr}{end+1}=Out_Of_Focus_Cells();
setappdata(0,'artifactHandles',artifactHandles);
populateCellArtifactOperationListbox(handles.cellArtifactOperationListbox,...
  handles);
set(handles.cellArtifactOperationListbox,'Value',...
  length(artifactHandles.temp_cell_artifact_list{subpop_nr}));
guidata(hObject, handles);
cellArtifactOperationListbox_Callback(handles.cellArtifactOperationListbox,...
  eventdata, handles);


% --- Executes on selection change in cellArtifactOperationListbox.
function cellArtifactOperationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Get the description of the first selected Model
%selectedString=get(handles.operationListbox,'String');
selectedValue=get(handles.cellArtifactOperationListbox,'Value');
subpop_nr=get(handles.subpopNrCB,'Value');
if(isempty(artifactHandles.temp_cell_artifact_list))
  hideCellArtifactOperationParameterPanel(handles,'off');
  return;
else  
  hideCellArtifactOperationParameterPanel(handles,'on');
end
cellArtifactObj=artifactHandles.temp_cell_artifact_list{subpop_nr}{selectedValue};
%Set the setParameterPanel function parameters
operationObj=cellArtifactObj;
setCellArtifactParam(hObject,handles,operationObj,artifactHandles)
guidata(hObject, handles);


function hideCellArtifactOperationParameterPanel(handles,isVisible)
set(handles.text5,'Visible',isVisible);
set(handles.cellArtifactOperationTypePopupMenu,'Visible',isVisible);
set(handles.cellArtifactSaveButton,'Visible',isVisible);
set(handles.cellArtifactViewButton,'Visible',isVisible);


% --- Executes during object creation, after setting all properties.
function cellArtifactOperationListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Outputs from this function are returned to the command line.
function varargout = define_artifact_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Return the image_artifact_list
%Cell artifact will have been automaticly saved if the back button has been
%pressed (see backButton_Callback)
artifactHandles=getappdata(0,'artifactHandles');
varargout{1}=artifactHandles.image_artifact_list;
if(~isempty(handles))
  delete(handles.figure1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Image Artifact Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function populateImageArtifactOperationListbox(hObject,handles)
artifactHandles=getappdata(0,'artifactHandles');
operation_names=cell(length(artifactHandles.temp_image_artifact_list),1);
for op_number=1:length(artifactHandles.temp_image_artifact_list)
    operation_names{op_number}=...
      class(artifactHandles.temp_image_artifact_list{op_number});
end
set(handles.imageArtifactOperationListbox,'String',operation_names);
set(handles.imageArtifactOperationListbox,'Value',1);
guidata(hObject, handles);


function setImageArtifactParam(hObject,handles,operationObj,artifactHandles)
objectDescriptionHandle=handles.imageArtifactDescription;
handleName='artifactHandles';
allowed_types=get(handles.imageArtifactOperationTypePopupMenu,'String');
operationTypePopupMenu=handles.imageArtifactOperationTypePopupMenu;
artifactHandles.imageArtifactParametersLabel=[];
artifactHandles.imageArtifactParametersField=[];
parametersLabelList=artifactHandles.imageArtifactParametersLabel;
parametersFieldList=artifactHandles.imageArtifactParametersField;
parentPanel=handles.imageArtifactPanel;
subpopulationList=[];%Should never depend of subpopulation...
[parametersLabelList,parametersFieldList]=setParametersPanel(hObject,handles,...
  operationObj,objectDescriptionHandle,handleName,...
  @clearImageArtifactParameters,...
  allowed_types,operationTypePopupMenu,parametersLabelList,...
  parametersFieldList,parentPanel,subpopulationList);
artifactHandles.imageArtifactParametersLabel=parametersLabelList;
artifactHandles.imageArtifactParametersField=parametersFieldList;
setappdata(0,'artifactHandles',artifactHandles);


%Remove all previous Model parameters
function handles=clearImageArtifactParameters()
%Clear the all parameters
artifactHandles=getappdata(0,'artifactHandles');
if isfield(artifactHandles,'imageArtifactParametersLabel')
    for i=1:length(artifactHandles.imageArtifactParametersLabel)
        if(ishandle(artifactHandles.imageArtifactParametersLabel{i}))
            delete(artifactHandles.imageArtifactParametersLabel{i});
        end
    end
    handles=rmfield(artifactHandles,'imageArtifactParametersLabel');
end
if isfield(artifactHandles,'imageArtifactParametersField')
    for i=1:length(artifactHandles.imageArtifactParametersField)
        if(ishandle(artifactHandles.imageArtifactParametersField{i}))
            delete(artifactHandles.imageArtifactParametersField{i});
        end
    end
    handles=rmfield(artifactHandles,'imageArtifactParametersField');
    setappdata(0,'artifactHandles',artifactHandles);
end


% --- Executes on selection change in imageArtifactOperationListbox.
function imageArtifactOperationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Get the description of the first selected Model
%selectedString=get(handles.operationListbox,'String');
selectedValue=get(handles.imageArtifactOperationListbox,'Value');
if(isempty(artifactHandles.temp_image_artifact_list))
  hideImageArtifactOperationParameterPanel(handles,'off');
  return;
else  
  hideImageArtifactOperationParameterPanel(handles,'on');
end
imageArtifactObj=artifactHandles.temp_image_artifact_list{selectedValue};
setappdata(0,'artifactHandles',artifactHandles);
setImageArtifactParam(hObject,handles,imageArtifactObj,artifactHandles);
guidata(hObject, handles);


function hideImageArtifactOperationParameterPanel(handles,isVisible)
set(handles.text5,'Visible',isVisible);
set(handles.imageArtifactOperationTypePopupMenu,'Visible',isVisible);
set(handles.imageArtifactSaveButton,'Visible',isVisible);
set(handles.imageArtifactViewButton,'Visible',isVisible);


% --- Executes during object creation, after setting all properties.
function imageArtifactOperationListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imageArtifactAddButton.
function imageArtifactAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Instantiate the first most basic image artifact plugin: Add_Basal_Brightness
%TODO: Make sure it is always here...
artifactHandles.temp_image_artifact_list{end+1}=Add_Basal_Brightness();
setappdata(0,'artifactHandles',artifactHandles);
populateImageArtifactOperationListbox(handles.imageArtifactOperationListbox, handles);
set(handles.imageArtifactOperationListbox,'Value',...
  length(artifactHandles.temp_image_artifact_list));
guidata(hObject, handles);
imageArtifactOperationListbox_Callback(handles.imageArtifactOperationListbox, eventdata, handles);


% --- Executes on button press in imageArtifactRemoveButton.
function imageArtifactRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
operation_to_remove=get(handles.imageArtifactOperationListbox,'Value');
artifactHandles.temp_image_artifact_list = ...
  removeFromCellArray(artifactHandles.temp_image_artifact_list,...
  operation_to_remove);
setappdata(0,'artifactHandles',artifactHandles);
populateImageArtifactOperationListbox(hObject, handles);
set(handles.imageArtifactOperationListbox,...
  'Value',max(get(handles.imageArtifactOperationListbox,'Value')-1,1));
guidata(hObject, handles);
imageArtifactOperationListbox_Callback(hObject, eventdata, handles);


% --- Executes on button press in imageArtifactSaveButton.
function imageArtifactSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Get the Object Type
selectedString=get(handles.imageArtifactOperationTypePopupMenu,'String');
selectedValue=get(handles.imageArtifactOperationTypePopupMenu,'Value');
%Create new Shape Model Object
artifactObj=eval(selectedString{selectedValue});
artifactObj=saveObjectFromParameters(artifactObj,...
  artifactHandles.imageArtifactParametersField,[]);
%Save the created Object
operation_number=get(handles.imageArtifactOperationListbox,'Value');
artifactHandles.temp_image_artifact_list{operation_number}=artifactObj;
%Save the handle
setappdata(0,'artifactHandles',artifactHandles);
%Repopulate the Listbox of Image Artifact Operation
populateImageArtifactOperationListbox(hObject,handles);
guidata(hObject, handles);
set(handles.imageArtifactOperationListbox,'Value',operation_number);
guidata(hObject, handles);
%Populate the cellArtifactOperation parameters corresponding to the selected
%operation
setappdata(0,'artifactHandles',artifactHandles);
setImageArtifactParam(hObject,handles,artifactObj,artifactHandles);
%setImageArtifactParametersPanel(hObject,handles,artifactObj);
guidata(hObject, handles);


% --- Executes on button press in imageArtifactViewButton.
function imageArtifactViewButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactViewButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in imageArtifactOperationTypePopupMenu.
function imageArtifactOperationTypePopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationTypePopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Get the imageArtifactObject selected
selectedValue=get(handles.imageArtifactOperationListbox,'Value');
imageArtifactObj=artifactHandles.temp_image_artifact_list{selectedValue};
contents = cellstr(get(hObject,'String'));
imageArtifactNameSelected=contents{get(hObject,'Value')};
imageArtifactObjSelected=eval(imageArtifactNameSelected);
setappdata(0,'artifactHandles',artifactHandles);
if(strcmp(class(imageArtifactObj),class(imageArtifactObjSelected)))
  artifactObj=imageArtifactObj;
else
  artifactObj=imageArtifactObjSelected;
end
setImageArtifactParam(hObject,handles,artifactObj,artifactHandles);


% --- Executes during object creation, after setting all properties.
function imageArtifactOperationTypePopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationTypePopupMenu (see GCBO)
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
uiresume(handles.figure1);


% --- Executes on button press in backButton.
function backButton_Callback(hObject, eventdata, handles)
% hObject    handle to backButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
artifactHandles=getappdata(0,'artifactHandles');
%Replace for each  Subpopulation Object the cell_artifacts operations by
%the temp one
%So Modify the Subpopulation Object therefore no need to return or save
%it (since it overclass handle, it is saved by reference).
for i=1:length(artifactHandles.subpopulations)
  artifactHandles.subpopulations{i}.cell_artifacts=...
    artifactHandles.temp_cell_artifact_list{i};
end
%Save the temp Image Artifacts as the new one
artifactHandles.image_artifact_list=artifactHandles.temp_image_artifact_list;
setappdata(0,'artifactHandles',artifactHandles);
uiresume(handles.figure1);
