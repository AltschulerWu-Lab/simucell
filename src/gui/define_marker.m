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

% Last Modified by GUIDE v2.5 05-Jan-2012 17:10:27

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
set(handles.title,'String',['Define marker ' shapeHandles.markerName...
  ' for object ' shapeHandles.objectName...
  ' of subpopulation ' num2str(shapeHandles.subpopNrsubpopNr)]);
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
varargout{1} = handles.output;


% --- Executes on selection change in operationListbox.
function operationListbox_Callback(hObject, eventdata, handles)
% hObject    handle to operationListbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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


% --- Executes on button press in removeOperationButton.
function removeOperationButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeOperationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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
