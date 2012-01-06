function varargout = simucellGUI(varargin)
% SIMUCELLGUI MATLAB code for simucellGUI.fig
%      SIMUCELLGUI, by itself, creates a new SIMUCELLGUI or raises the existing
%      singleton*.
%
%      H = SIMUCELLGUI returns the handle to a new SIMUCELLGUI or the handle to
%      the existing singleton*.
%
%      SIMUCELLGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMUCELLGUI.M with the given input arguments.
%
%      SIMUCELLGUI('Property','Value',...) creates a new SIMUCELLGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simucellGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simucellGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simucellGUI

% Last Modified by GUIDE v2.5 05-Jan-2012 17:48:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simucellGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @simucellGUI_OutputFcn, ...
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


% --- Executes just before simucellGUI is made visible.
function simucellGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simucellGUI (see VARARGIN)

% Choose default command line output for simucellGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);  
axis(handles.Header);
setappdata(0,'handles',handles);
img=imread('header.png');
image(img,'parent',handles.Header);
axis off;

%store the row headers into a cell array
rowHeaders = {'Subpop'};
%set the row labels
set(handles.uitable1,'RowName',rowHeaders);
%do the same for the column headers
columnHeaders = {'#'};
set(handles.uitable1,'ColumnName',columnHeaders);
%get the data from the UITABLE
tableData=[1];%update the table
set(handles.uitable1,'data',tableData);
initMyHandle();
% Update handles structure
guidata(hObject, handles);
%initialize this selectedCellsVariable
handles.selectedCells = [];
populateTable(hObject,handles);



% UIWAIT makes simucellGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simucellGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in editMarkerButton.
function editMarkerButton_Callback(hObject, eventdata, handles)
% hObject    handle to editMarkerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
subpopSelected=tableData{selectedCellPosition(1,1),1};
objectSelected=tableData{selectedCellPosition(1,1),2};
columnHeader=getColumnHeaders(handles);
markerSelected=columnHeader{selectedCellPosition(1,2)};
markerProperty=myhandles.simucell_data.subpopulations{subpopSelected}.markers.(markerSelected).(objectSelected);

subpop=myhandles.simucell_data.subpopulations{subpopSelected};
%currentObject=myhandles.simucell_data.subpopulations{subpopSelected}.objects.(objectSelected);
[markerProperty,name] = define_marker(subpop,markerProperty,markerSelected,objectSelected,subpopSelected);
if (~isempty(markerProperty.operations))
  myhandles.simucell_data.subpopulations{subpopSelected}.markers.(markerSelected).(objectSelected)=markerProperty;
  setappdata(0,'myhandles',myhandles);
  populateTable(hObject,handles);
end




% --- Executes on button press in newMarkerButton.
function newMarkerButton_Callback(hObject, eventdata, handles)
% hObject    handle to newMarkerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
%selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
%tableData = get(handles.uitable1,'data');
%subpopSelected=tableData{selectedCellPosition(1,1),1};
prompt = {['Enter new Marker Name' ' :']};
dlg_title = ['Add a new marker'] ;
num_lines = 1;
def = {'Name'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
  return;
end
subpop=myhandles.simucell_data.subpopulations;
for i=1:length(subpop)
  subpop{i}.markers.addprop(answer{1});
  subpop{i}.markers.(answer{1})=...
    Marker(subpop{i}.objects);
end
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);

% --- Executes on button press in removeMarkerButton.
function removeMarkerButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeMarkerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RemoveObject.
function RemoveObject_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
subpopSelected=tableData{selectedCellPosition(1,1),1};
objectSelected=tableData{selectedCellPosition(1,1),2};
myhandles.simucell_data.subpopulations{subpopSelected}.delete_shape(objectSelected);
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);


% --- Executes on button press in AddObject.
function AddObject_Callback(hObject, eventdata, handles)
% hObject    handle to AddObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
subpopSelected=tableData{selectedCellPosition(1,1),1};
prompt = {['Enter new Object Name for subpopulation ' num2str(subpopSelected) ' :']};
dlg_title = ['Add a new object for subpopulation' num2str(subpopSelected)] ;
num_lines = 1;
def = {'Name'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer)
  return;
end
objectList=myhandles.simucell_data.subpopulations{subpopSelected}.objects;
objectList.addprop(answer{1});
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);


% --- Executes on button press in EditShape.
function EditShape_Callback(hObject, eventdata, handles)
% hObject    handle to EditShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
subpopSelected=tableData{selectedCellPosition(1,1),1};
objectSelected=tableData{selectedCellPosition(1,1),2};
subpop=myhandles.simucell_data.subpopulations{subpopSelected};
currentObject=myhandles.simucell_data.subpopulations{subpopSelected}.objects.(objectSelected);
[shapeObj,name] = define_shape(objectSelected,subpopSelected,...
  myhandles.simucell_data.subpopulations{subpopSelected}.objects,...
  currentObject,subpop);
%uiwait;
if (~isempty(shapeObj))
  myhandles.simucell_data.subpopulations{subpopSelected}.objects.(objectSelected)=shapeObj;
  setappdata(0,'myhandles',myhandles);
  populateTable(hObject,handles);
end


% --- Executes on button press in RemoveSubpop.
function RemoveSubpop_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveSubpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
subpopSelected=tableData{selectedCellPosition(1,1),1};
answer = questdlg({['You are about to delete subpopulation '...
  num2str(subpopSelected)];'including ALL its objects.';...
  'Are you sure you want to do that?'},...
  'Delete Subpopulation');
switch answer
case 'No'
  return;
case 'Cancel'
  return;
end
myhandles.simucell_data.subpopulations=...
  removeFromCellArray(myhandles.simucell_data.subpopulations,subpopSelected);
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);


% --- Executes on button press in AddSubpop.
function AddSubpop_Callback(hObject, eventdata, handles)
myhandles=getappdata(0,'myhandles');
subpopNr=length(myhandles.simucell_data.subpopulations);
myhandles.simucell_data.subpopulations{subpopNr+1}=Subpopulation();
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);
subpopList=[];
for i=1:subpopNr+1
  subpopList{i}=i;
end
set(handles.subpopNrCB,'String',subpopList);


function columnHeaders=getColumnHeaders(handles)
  columnHeaders=get(handles.uitable1,'ColumnName');
  
  
function rowHeaders=getRowHeaders(handles)
  rowHeaders=get(handles.uitable1,'RowName');

  
function populateTable(hObject,handles)
%Store the row headers into a cell array
rowHeaders = {'1'};
%do the same for the column headers
columnHeaders = {'#'};
myhandles=getappdata(0,'myhandles');
subpops=myhandles.simucell_data.subpopulations;
%Init the tableData
tableData=cell(0);
tableData{1,1}=1;
rowNr=0;
subpopNr=length(subpops);
objectNr=0;
for i=1:subpopNr
  rowNr=rowNr+1;
  rowHeaders{rowNr}='Subpop';
  tableData{rowNr,1}=i;
  objs= properties(subpops{i}.objects);
  
  if(~isempty(objs))
    for j=1:length(objs)
      tableData{rowNr,1}=i;
      obj=subpops{i}.objects.(objs{j});
      if(~isempty(obj))
        tableData{rowNr,3}='Defined';
      else
        tableData{rowNr,3}='-';
      end
      tableData{rowNr,2}=objs{j};
      if(j<length(objs))
        rowNr=rowNr+1;
      end
      objectNr=objectNr+1;
    end
  end  
end
%Count the number of marker
%If not the same for all the subpopulation, give an error
nrMarker=0;
for i=1:subpopNr
  if(isempty(properties(subpops{1}.markers)))
    nrMark=0;
  else
    nrMark=length(properties(subpops{1}.markers));
  end
  if(i==1)
    nrMarker=nrMark;
  elseif(nrMarker~=nrMark)
    errordlg('You have to define the same marker for all the subpopulation');
  end
end
%Fill the table for the marker
for i=1:nrMarker
  markers=properties(subpops{1}.markers);
  columnHeaders{3+i}=markers{i};
  rowNr=0;
  for j=1:subpopNr
    rowNr=rowNr+1;
    objs= properties(subpops{j}.objects);
    if(~isempty(objs))
      for k=1:length(objs)
        if (isempty(subpops{j}.markers.(markers{i}).(objs{k}).operations))
          tableData{rowNr,3+i}='-';          
        else
          tableData{rowNr,3+i}='Defined';          
        end
        if(k<length(objs))
          rowNr=rowNr+1;
        end  
      end
    end  
  end
end
if(objectNr>1)
  columnHeaders{2}='Object Name';
  columnHeaders{3}='Shape';
end
%Set the row labels
set(handles.uitable1,'RowName',rowHeaders);
set(handles.uitable1,'ColumnName',columnHeaders);
set(handles.uitable1,'data',tableData);
%Update handles structure
guidata(hObject, handles);


function subpop=test()
subpop=cell(0);
subpop{1}=Subpopulation();
subpop{1}.placement=Random_Placement();
set(subpop{1}.placement,'boundary',100);
objects1=subpop{1}.objects;

objects1.addprop('cytoplasm');
objects1.cytoplasm=Cytoplasm_model;
set(objects1.cytoplasm,'radius',30,'eccentricity',0.2);

objects1.addprop('nucleus');
objects1.nucleus=Centered_nucleus_model;
set(objects1.nucleus,'centered_around',objects1.cytoplasm,'eccentricity',0);
  
  
function initMyHandle()
  %myhandles.simucell_data.subpopulations{1}=Subpopulation();
  myhandles.simucell_data.subpopulations=test();
  setappdata(0,'myhandles',myhandles);  


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
%Every time the cell selection changes, we update this data
%eventdata stores the indices of the selected cells
handles.selectedCells = eventdata.Indices;
%update the gui data
guidata(hObject, handles);



function imageWidthEdit_Callback(hObject, eventdata, handles)
% hObject    handle to imageWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageWidthEdit as text
%        str2double(get(hObject,'String')) returns contents of imageWidthEdit as a double


% --- Executes during object creation, after setting all properties.
function imageWidthEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageWidthEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imageHeightEdit_Callback(hObject, eventdata, handles)
% hObject    handle to imageHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageHeightEdit as text
%        str2double(get(hObject,'String')) returns contents of imageHeightEdit as a double


% --- Executes during object creation, after setting all properties.
function imageHeightEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageHeightEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cellNrEdit_Callback(hObject, eventdata, handles)
% hObject    handle to cellNrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cellNrEdit as text
%        str2double(get(hObject,'String')) returns contents of cellNrEdit as a double


% --- Executes during object creation, after setting all properties.
function cellNrEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cellNrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function imageNrEdit_Callback(hObject, eventdata, handles)
% hObject    handle to imageNrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imageNrEdit as text
%        str2double(get(hObject,'String')) returns contents of imageNrEdit as a double


% --- Executes during object creation, after setting all properties.
function imageNrEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imageNrEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in subpopNrCB.
function subpopNrCB_Callback(hObject, eventdata, handles)
% hObject    handle to subpopNrCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns subpopNrCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from subpopNrCB


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



function fractionSubpopEdit_Callback(hObject, eventdata, handles)
% hObject    handle to fractionSubpopEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fractionSubpopEdit as text
%        str2double(get(hObject,'String')) returns contents of fractionSubpopEdit as a double


% --- Executes during object creation, after setting all properties.
function fractionSubpopEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fractionSubpopEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveSimucellButton.
function saveSimucellButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveSimucellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in runSimucellButton.
function runSimucellButton_Callback(hObject, eventdata, handles)
% hObject    handle to runSimucellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
