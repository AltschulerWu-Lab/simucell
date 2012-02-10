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

% Last Modified by GUIDE v2.5 07-Feb-2012 15:38:29

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

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes define_artifact wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = define_artifact_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in imageArtifactOperationListbox.
function imageArtifactOperationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns imageArtifactOperationListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageArtifactOperationListbox


% --- Executes during object creation, after setting all properties.
function imageArtifactOperationListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in imageArtifactAddButton.
function imageArtifactAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in imageArtifactRemoveButton.
function imageArtifactRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in imageArtifactSaveButton.
function imageArtifactSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to imageArtifactSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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

% Hints: contents = cellstr(get(hObject,'String')) returns imageArtifactOperationTypePopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from imageArtifactOperationTypePopupMenu


% --- Executes during object creation, after setting all properties.
function imageArtifactOperationTypePopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageArtifactOperationTypePopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cellArtifactOperationTypePopupMenu.
function cellArtifactOperationTypePopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationTypePopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cellArtifactOperationTypePopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cellArtifactOperationTypePopupMenu


% --- Executes during object creation, after setting all properties.
function cellArtifactOperationTypePopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationTypePopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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


% --- Executes on button press in cellArtifactRemoveButton.
function cellArtifactRemoveButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactRemoveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in cellArtifactAddButton.
function cellArtifactAddButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactAddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in cellArtifactOperationListbox.
function cellArtifactOperationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cellArtifactOperationListbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cellArtifactOperationListbox


% --- Executes during object creation, after setting all properties.
function cellArtifactOperationListbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellArtifactOperationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
