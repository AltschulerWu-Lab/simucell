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

% Last Modified by GUIDE v2.5 02-Jan-2012 12:15:51

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


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
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
define_shape_gui = define_shape(objectSelected,subpopSelected,...
  myhandles.simucell_data.subpopulations{subpopSelected}.objects,...
  currentObject,subpop);


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
  subpop=subpops{i};
  rowNr=rowNr+1;
  rowHeaders{rowNr}='Subpop';
  tableData{rowNr,1}=i;
  objs= properties(subpops{i}.objects);
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
if(objectNr>1)
  columnHeaders{2}='Object Name';
  columnHeaders{3}='Shape';
end
%set the row labels
set(handles.uitable1,'RowName',rowHeaders);
set(handles.uitable1,'ColumnName',columnHeaders);
set(handles.uitable1,'data',tableData);
% Update handles structure
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
