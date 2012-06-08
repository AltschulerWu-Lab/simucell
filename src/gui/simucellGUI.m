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

% Last Modified by GUIDE v2.5 08-Mar-2012 15:06:53

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

%Add the version on top of the Main Window
version=fileread('version.txt');
set(handles.figure1,'name', ['SimuCell v' version]);

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
myhandles=getappdata(0,'myhandles');
myhandles.simucell_data=populateImageParameters(handles,myhandles.simucell_data);
setappdata(0,'myhandles',myhandles);



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
if(isempty(selectedCellPosition))  
  warndlg('Select the Marker you want to edit!');
  return;
end
subpopSelected=tableData{selectedCellPosition(1,1),1};
if(size(tableData,1)<selectedCellPosition(1,1)||size(tableData,2)<2)
  warndlg('You have to define an Object/Shape first!');
  return;
end
objectSelected=tableData{selectedCellPosition(1,1),2};
columnHeader=getColumnHeaders(handles);
if(selectedCellPosition(1,2)<4 ) 
  warndlg('Select the Marker you want to edit!');
  return;
end
markerSelected=columnHeader{selectedCellPosition(1,2)};
markerProperty=myhandles.simucell_data.subpopulations{subpopSelected}.markers.(markerSelected).(objectSelected);
subpop=myhandles.simucell_data.subpopulations{subpopSelected};
[markerProperty,name,markerColor] = define_marker(subpop,markerProperty,markerSelected,objectSelected,subpopSelected);
myhandles.simucell_data.subpopulations{subpopSelected}.markers.(markerSelected).color=Colors.(markerColor);
populateTable(hObject,handles);

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
mc = ?Colors;
nrColor = length(mc.EnumeratedValues);
for i=1:nrColor
  colorList{1,i}=mc.EnumeratedValues{i}.Name;
end
S.Name   = { '' '' };
S.Color = {colorList};
answer = StructDlg(S,'Add a New Marker','',[50 40 50 10]);

% prompt = {['Enter new Marker Name' ' :']};
% dlg_title = ['Add a new marker'] ;
% num_lines = 1;
% def = {'Name'};
% answer = inputdlg(prompt,dlg_title,num_lines,def);
if isempty(answer) || isempty(answer.Name)
  return;
end

if any(strcmp(answer.Name, properties(myhandles.simucell_data.subpopulations{1}.markers)))
  warndlg('An Marker has already been defined with this name, please choose an other name.','Marker Name can not be identical');
  return;
end
if(~isvarname(answer.Name))
  warndlg('Marker name should not contain space, accent or start with a number.','Wrong marker name synthax');
  return; 
end



subpop=myhandles.simucell_data.subpopulations;
for i=1:length(subpop)
  subpop{i}.markers.addprop(answer.Name);
  subpop{i}.markers.(answer.Name)=...
    Marker(subpop{i}.objects,Colors.(answer.Color));
end
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);

% --- Executes on button press in removeMarkerButton.
function removeMarkerButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeMarkerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
subpopSelected=tableData{selectedCellPosition(1,1),1};
columnHeader=getColumnHeaders(handles);
to_be_deleted_name=columnHeader{selectedCellPosition(1,2)};

number_of_subpopulations=length(myhandles.simucell_data.subpopulations);
obv_del=cell(number_of_subpopulations,1);
all_del=cell(number_of_subpopulations,1);
prob_del=cell(number_of_subpopulations,1);
all_probs=cell(0);
all_obv=cell(0);
for subpop_num=1:number_of_subpopulations
    to_be_deleted_class= myhandles.simucell_data.subpopulations{subpop_num}.markers.(to_be_deleted_name);
    [obv_del{subpop_num},all_del{subpop_num}]=myhandles.simucell_data.subpopulations{subpop_num}.calculate_all_dependancies(...
    to_be_deleted_class);
    prob_del{subpop_num}=setxor(obv_del{subpop_num},all_del{subpop_num});
    prob_del{subpop_num}=cellfun(@(z) [ num2str(subpop_num) '>' z ],prob_del{subpop_num},'UniformOutput',false);
    if(~isempty(prob_del{subpop_num}))
        all_probs={all_probs{:}, prob_del{subpop_num}{:}};
    end
    if(~isempty(obv_del{subpop_num}))
        all_obv={all_obv{:},obv_del{subpop_num}{:}};
    end
end

if(isempty(all_probs))
    button=questdlg({'Removing the following:',all_obv{:}},'Confirm Delete','Delete','Cancel','Cancel');
    switch button
        case 'Delete'
            for subpop_num=1:number_of_subpopulations
                myhandles.simucell_data.subpopulations{subpop_num}.delete_marker(to_be_deleted_name);
            end
        otherwise
            
    end
else
    msgbox({'Attempting to remove:',to_be_deleted_name,...
        'However these objects will be affected:',all_probs{:}},'Delete Aborted!','error');
end
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);


% --- Executes on button press in RemoveObject.
function RemoveObject_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
selectedCellPosition = handles.selectedCells;
%get the data from the UITABLE
tableData = get(handles.uitable1,'data');
if(isempty(selectedCellPosition))  
  warndlg('Select the Object/Shape you want to Remove!');
  return;
end
if(size(tableData,1)<selectedCellPosition(1,1)||size(tableData,2)<2)
  warndlg('You have to define an Object/Shape first!');
  return;
end

subpopSelected=tableData{selectedCellPosition(1,1),1};
to_be_deleted_name=tableData{selectedCellPosition(1,1),2};
to_be_deleted_class= myhandles.simucell_data.subpopulations{subpopSelected}.objects.(to_be_deleted_name);

[obv_del,all_del]=myhandles.simucell_data.subpopulations{subpopSelected}.calculate_all_dependancies(...
    to_be_deleted_class);

if(isempty(setxor(obv_del,all_del)))
    button=questdlg({'Removing the following:',obv_del{:}},'Confirm Delete','Delete','Cancel','Cancel');
    switch button
        case 'Delete'
            if isa(to_be_deleted_class,'SimuCell_Object')
                myhandles.simucell_data.subpopulations{subpopSelected}.delete_shape(to_be_deleted_name);
            elseif(isa(to_be_deleted_class,'Marker'))
                myhandles.simucell_data.subpopulations{subpopSelected}.delete_marker(to_be_deleted_name);
            else
                disp('Confused by object type');
            end
        otherwise
            
    end
else
    prob_del=setxor(obv_del,all_del);
    msgbox({'Attempting to remove:',obv_del{:},...
        'However these objects will be affected:',prob_del{:}},'Delete Aborted!','error'); 
    
end
setappdata(0,'myhandles',myhandles);
%remove_function(subpopSelected,to_be_deleted_class,to_be_deleted_name);
populateTable(hObject,handles);

function remove_function(subpopSelected,to_be_deleted_class,to_be_deleted_name)
myhandles=getappdata(0,'myhandles');


[obv_del,all_del]=myhandles.simucell_data.subpopulations{subpopSelected}.calculate_all_dependancies(...
    to_be_deleted_class);

if(isempty(setxor(obv_del,all_del)))
    button=questdlg({'Removing the following:',obv_del{:}},'Confirm Delete','Delete','Cancel','Cancel');
    switch button
        case 'Delete'
            if isa(to_be_deleted_class,'SimuCell_Object')
                myhandles.simucell_data.subpopulations{subpopSelected}.delete_shape(to_be_deleted_name);
            elseif(isa(to_be_deleted_class,'Marker'))
                myhandles.simucell_data.subpopulations{subpopSelected}.delete_marker(to_be_deleted_name);
            else
                disp('Confused by object type');
            end
        otherwise
            
    end
else
    prob_del=setxor(obv_del,all_del);
    msgbox({'Attempting to remove:',obv_del{:},...
        'However these objects will be affected:',prob_del{:}},'Delete Aborted!','error'); 
    
end
setappdata(0,'myhandles',myhandles);


% --- Executes on button press in AddObject.
function AddObject_Callback(hObject, eventdata, handles)
% hObject    handle to AddObject (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');


for i=1:length(myhandles.simucell_data.subpopulations)
  subpopList{1,i}=num2str(i);
end
S.Name   = { '' '' };
S.Subpopulation = {subpopList};
answer = StructDlg(S,'Add a New Object','',[50 40 50 10]);
if isempty(answer) || isempty(answer.Name)
  errordlg('You must set a name to the new Object (can not be empty)','Enter a Object Name');
  return;
end
%objectList=myhandles.simucell_data.subpopulations{answer.Subpopulation}.objects;
%objectList.addprop(answer.Name);
if any(strcmp(answer.Name, properties(myhandles.simucell_data.subpopulations{answer.Subpopulation}.objects)))
  warndlg('An Object/Shape already use this name for this Subpopulation, please choose an other one.','Object Name can not be identical');
  return;
end
if(~isvarname(answer.Name))
  warndlg('Object/Shape name should not contain space, accent or start with a number.','Wrong object name synthax');
  return; 
end
myhandles.simucell_data.subpopulations{answer.Subpopulation}.add_object(answer.Name);
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
if(isempty(selectedCellPosition))  
  warndlg('Select the Object/Shape you want to edit!');
  return;
end
if(size(tableData,1)<selectedCellPosition(1,1)||size(tableData,2)<2)
  warndlg('You have to define an Object/Shape first!');
  return;
end
subpopSelected=tableData{selectedCellPosition(1,1),1};
objectSelected=tableData{selectedCellPosition(1,1),2};
subpop=myhandles.simucell_data.subpopulations{subpopSelected};
currentObject=myhandles.simucell_data.subpopulations{subpopSelected}.objects.(objectSelected);
[shapeObj,name] = define_shape(objectSelected,subpopSelected,...
  myhandles.simucell_data.subpopulations{subpopSelected}.objects,...
  currentObject,subpop);
%uiwait;
if (~isempty(shapeObj))
  myhandles.simucell_data.subpopulations{subpopSelected}.objects.(objectSelected).model=shapeObj.model;
  setappdata(0,'myhandles',myhandles);
  [is_ok,message,bio_graph]=myhandles.simucell_data.subpopulations{subpopSelected}.check_shape_dependancies();
  if(~is_ok)
      if(isa(bio_graph,'biograph.biograph'))
      choice = questdlg(message, ...
          'Bad Model Choice', ...
          'View Object Connections','Change Model', 'Proceed Anyway!','Change Model');
      else
         choice = questdlg(message, ...
          'Bad Model Choice', ...
          'Change Model','Proceed Anyway!','Change Model'); 
      end
          
      % Handle response
      switch choice
          case 'Proceed Anyway!'
             
          case 'View Object Connections'
             view(bio_graph);
          case 'Change Model'
              EditShape_Callback(hObject, eventdata,handles);
      end
  end
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
subpopNr=length(myhandles.simucell_data.subpopulations);
subpopList=cell(1,subpopNr);
myhandles.simucell_data.population_fractions=zeros(1,subpopNr);
for i=1:subpopNr
  subpopList{i}=i;
  myhandles.simucell_data.population_fractions(i)=1/(subpopNr);
end
setappdata(0,'myhandles',myhandles);  
set(handles.subpopNrCB,'String',subpopList);
if(subpopNr>0)
  set(handles.fractionSubpopEdit,'String',...
    num2str(myhandles.simucell_data.population_fractions(1)*100));
end
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);


% --- Executes on button press in AddSubpop.
function AddSubpop_Callback(hObject, eventdata, handles)
myhandles=getappdata(0,'myhandles');
subpopNr=length(myhandles.simucell_data.subpopulations);
myhandles.simucell_data.subpopulations{subpopNr+1}=Subpopulation();
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);
subpopList=cell(1,subpopNr+1);
for i=1:subpopNr+1
  subpopList{i}=i;
  myhandles.simucell_data.population_fractions(i)=1/(subpopNr+1);
end
setappdata(0,'myhandles',myhandles);  
set(handles.subpopNrCB,'String',subpopList);
set(handles.fractionSubpopEdit,'String',...
  num2str(myhandles.simucell_data.population_fractions(1)*100));



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
      if(~isempty(obj.model))
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


markers=cell(0);
for i=1:length(subpops)
  markers=union(markers,properties(subpops{1}.markers));
end


%Fill the table for the marker
for i=1:nrMarker
  %markers=properties(subpops{1}.markers);
  columnHeaders{3+i}=markers{i};
  rowNr=0;
  for j=1:subpopNr
    rowNr=rowNr+1;
    objs= properties(subpops{j}.objects);
    if(~isempty(objs))
      for k=1:length(objs)
        %Create the marker for the subpopulation that didn't have it so
        %all subpopulations will have the same marker
        if(length(findprop(subpops{j}.markers,markers{i}))==0)          
          add_marker(subpops{j},markers{i},Colors.Blue);
        end
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


function simucell_data=test()
subpop=cell(0);
%subpopulation 1
subpop{1}=Subpopulation();
subpop{1}.placement=Random_Placement();


add_object(subpop{1},'nucleus');
subpop{1}.objects.nucleus.model=Nucleus_Model;
set(subpop{1}.objects.nucleus.model,'radius',15,'eccentricity',0.7);

% add_object(subpop{1},'nucleus');
% subpop{1}.objects.nucleus.model=SLML_Nucleus_Model;
% set(subpop{1}.objects.nucleus.model,'radius',30,...
%     'filename','/home/srajaram/Work/Code/SimuCell/Code/src/test/test_slml/endosome.mat');

add_object(subpop{1},'cytoplasm');
subpop{1}.objects.cytoplasm.model=Centered_Cytoplasm_Model;
set(subpop{1}.objects.cytoplasm.model,'radius',60,'eccentricity',0.9,'randomness',0.3,'centered_around',subpop{1}.objects.nucleus);


add_object(subpop{1},'lipid_droplets');
subpop{1}.objects.lipid_droplets.model=Lipid_Droplet_Model;
set(subpop{1}.objects.lipid_droplets.model,'droplet_radius',5,...
    'number_of_droplets',5,'number_of_clusters',2,...
    'nucleus',subpop{1}.objects.nucleus,'cytoplasm',subpop{1}.objects.cytoplasm);


add_object(subpop{1},'fiber');
subpop{1}.objects.fiber.model=Microtubule_Fibre_Model;
set(subpop{1}.objects.fiber.model,'nucleus',subpop{1}.objects.nucleus,...
    'cytoplasm',subpop{1}.objects.cytoplasm);

markers1=subpop{1}.markers;

add_marker(subpop{1},'DAPI',Colors.Blue);
op=Constant_Marker_Level();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.nucleus.AddOperation(op);
op=Perlin_Texture();
set(op,'length_scale',4,'frequency_falloff',1,'amplitude',0.25);
markers1.DAPI.nucleus.AddOperation(op);
op=Constant_Dependant_Marker_Level();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{1}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{1},'Actin',Colors.Green);
op=Constant_Marker_Level();
set(op,'mean_level',0.1,'sd_level',0);
markers1.Actin.cytoplasm.AddOperation(op);
op=Perlin_Texture();
markers1.Actin.cytoplasm.AddOperation(op);
op=Constant_Marker_Level();
set(op,'mean_level',0.8,'sd_level',0.1);
markers1.Actin.lipid_droplets.AddOperation(op);


add_marker(subpop{1},'MT',Colors.Red);
op=Constant_Marker_Level();
set(op,'mean_level',0.1,'sd_level',0);
markers1.MT.fiber.AddOperation(op);
op=Perlin_Texture();
set(op,'length_scale',6,'amplitude',0.1,'add_or_multiply','Add');
markers1.MT.fiber.AddOperation(op);

subpop{1}.compositing=Default_Compositing();
set(subpop{1}.compositing,'container_weight',0);


%subpopulation 2
subpop{2}=Subpopulation();
subpop{2}.placement=Random_Placement();
set(subpop{2}.placement,'boundary',100);

add_object(subpop{2},'cytoplasm');
subpop{2}.objects.cytoplasm.model=Cytoplasm_Model;
set(subpop{2}.objects.cytoplasm.model,'radius',40,'eccentricity',0.2);

add_object(subpop{2},'nucleus');
subpop{2}.objects.nucleus.model=Centered_Nucleus_Model;
set(subpop{2}.objects.nucleus.model,'centered_around',subpop{2}.objects.cytoplasm,'eccentricity',0);

markers1=subpop{2}.markers;

add_marker(subpop{2},'DAPI',Colors.Blue);
op=Constant_Marker_Level();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_Dependant_Marker_Level();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{2}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{2},'Actin',Colors.Green);
op=Cell_Density_Dependant_Marker_Level();
set(op,'falloff_type','Exponential','falloff_coefficient',2,'increasing_or_decreasing','Increasing');
markers1.Actin.cytoplasm.AddOperation(op);

op=Constant_Marker_Level();
set(op,'mean_level',0,'sd_level',0);
markers1.Actin.nucleus.AddOperation(op);

subpop{2}.compositing=Default_Compositing();
set(subpop{2}.compositing,'container_weight',0);

overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.05);

op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.05,'blur_radius',5);
subpop{1}.add_cell_artifact(op);
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.04,'blur_radius',4);
subpop{2}.add_cell_artifact(op);

simucell_data.image_artifacts=cell(0);
op=Add_Basal_Brightness();
set(op,'basal_level',0.15);
simucell_data.image_artifacts{1}=op;
op=Radial_Image_Gradient();
simucell_data.image_artifacts{2}=op;
set(op,'falloff_type','Sigmoidal','falloff_radius',50);

simucell_data.population_fractions=[0.3,0.7];
simucell_data.number_of_cells=5;
simucell_data.simucell_image_size=[500,500];
simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;




  
  
function initMyHandle()
  myhandles.simucell_data.subpopulations{1}=Subpopulation();
  %myhandles.simucell_data=test();
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
myhandles=getappdata(0,'myhandles');
propertyValue=get(handles.subpopNrCB,'Value');
set(handles.fractionSubpopEdit,'String',...
  num2str(myhandles.simucell_data.population_fractions(propertyValue)*100));




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

% --- Executes on button press in saveFractionSubpop.
function saveFractionSubpop_Callback(hObject, eventdata, handles)
% hObject    handle to saveFractionSubpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
subpopNr=get(handles.subpopNrCB,'Value');
subpopFraction=str2double(get(handles.fractionSubpopEdit,'String'));
myhandles.simucell_data.population_fractions(subpopNr)=subpopFraction/100;
if(sum(myhandles.simucell_data.population_fractions)~=1)
  warndlg('Error: make sure sum of subpopulation fraction is equal to 100%.');
end
setappdata(0,'myhandles',myhandles);  


% --- Executes on button press in saveSimucellButton.
function saveSimucellButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveSimucellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
if(sum(myhandles.simucell_data.population_fractions)~=1)
  warndlg('Error: make sure sum of subpopulation fraction is equal to 100%.');
  return;
end
[FileName,PathName]=uiputfile('*.m','Export SimuCell Script');
simucell_data = populateSimucell_data(handles,myhandles.simucell_data);
if(isnumeric(simucell_data))
  return;
end
simucell_data=setImagesParameterstoSimucellData(handles,simucell_data);
try
  generate_script_from_simucell(simucell_data,[PathName FileName]);
catch
end
FileName2=[FileName(1:end-2) '.mat'];
save([PathName FileName2], 'simucell_data');
msgbox(['Script and data structure have been saved in ' PathName FileName ' and ' PathName FileName2 '.']);
myhandles.simucell_data=simucell_data;
setappdata(0,'myhandles',myhandles);

function simucell_data=setImagesParameterstoSimucellData(handles,simucell_data)

imageWidth=str2double(get(handles.imageWidthEdit,'String'));
imageHeight=str2double(get(handles.imageHeightEdit,'String'));
cellNr=str2double(get(handles.cellNrEdit,'String'));
simucell_data.number_of_cells=cellNr;
simucell_data.simucell_image_size=[imageWidth,imageHeight];
%simucell_data.population_fractions=[0.5,0.5];

function simucell_data=populateSimucell_data(handles,simucell_data)
imageWidth=get(handles.imageWidthEdit,'String');
imageWidth=str2double(imageWidth);
imageHeight=get(handles.imageHeightEdit,'String');
imageHeight=str2double(imageHeight);
if(~isnumeric(imageWidth ) || ~isnumeric(imageHeight) )
  simucell_data=-1;
  errordlg('Image Size MUST be a number');
  return;
end
simucell_data.simucell_image_size=[imageWidth,imageHeight];
cellNr=get(handles.cellNrEdit,'String');
cellNr=str2double(cellNr);
if(~isnumeric(cellNr ) )
  simucell_data=-1;
  errordlg('# Cell MUST be a number');
  return;
end
simucell_data.number_of_cells=cellNr;

function simucell_data=populateImageParameters(handles,simucell_data)
if isfield(simucell_data,'simucell_image_size')
  set(handles.imageWidthEdit,'String',num2str(simucell_data.simucell_image_size(1)));
  set(handles.imageHeightEdit,'String',num2str(simucell_data.simucell_image_size(2)));
else
  set(handles.imageWidthEdit,'String', '500');
  set(handles.imageHeightEdit,'String', '500');
end  
if isfield(simucell_data,'number_of_cells')
  set(handles.cellNrEdit,'String',num2str(simucell_data.number_of_cells));
else
  set(handles.cellNrEdit,'String','10');  
end
subpopNr=length(simucell_data.subpopulations);
subpopList=cell(1,subpopNr);
for i=1:subpopNr
  subpopList{i}=i;
end
set(handles.subpopNrCB,'String',subpopList);
if ~isfield(simucell_data,'population_fractions')
  simucell_data.population_fractions=1;
end
set(handles.fractionSubpopEdit,'String',...
  num2str(simucell_data.population_fractions(1)*100));






% --- Executes on button press in runSimucellButton.
function runSimucellButton_Callback(hObject, eventdata, handles)
% hObject    handle to runSimucellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% setup_simucell_params(hObject, eventdata, handles)
myhandles=getappdata(0,'myhandles');
myhandles.simucell_data=setImagesParameterstoSimucellData(handles,myhandles.simucell_data);
myhandles.simucell_data.notifier=SimuCell_Engine_Notifier;
addlistener(myhandles.simucell_data.notifier,'warning',@RespondToEngineWarning);
addlistener(myhandles.simucell_data.notifier,'error_thrown',@RespondToEngineError);
setappdata(0,'myhandles',myhandles);
%position=get(handles.figure1,'Position');
h=waitbar(0,'Please wait..','Position',[400 400 300 60]);
number_of_images=0;
try
number_of_images=round(str2double(get(handles.imageNrEdit,'String')));    
simucell_result=simucell_engine(myhandles.simucell_data,number_of_images);
catch err
    
  close(h); 
  errordlg([err.message ' in ' err.stack(1).file ' line ' num2str(err.stack(1).line)]);
  rethrow(err);
  return;
end
waitbar(1,h,'Done');
close(h);
figure;
image(simucell_result(1).RGB_image);axis off;axis equal;
button = questdlg('Would you like to save your results?','Save?','Images & Data','Only Images','Neither','Neither');
switch button
    case 'Images & Data'
        prompt = {'Enter image prefix:','Enter data filename (without .mat):'};
        dlg_title = 'Naming';
        num_lines = 1;
        defaults = {'image_','simucell_result'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaults);
        
        folder_name = uigetdir('.','Save Folder');
        if(~isnumeric(folder_name))
            number_of_digits=floor(log10(number_of_images))+1;
            save([folder_name filesep answer{2} '.mat'],'simucell_result');
            for img_num=1:number_of_images
                filename=[ folder_name filesep answer{1} sprintf(['%0' num2str(number_of_digits) 'd'],img_num) '.png'];
                imwrite(simucell_result(img_num).RGB_image,filename);
            end
        end
    case  'Only Images'
        prompt = {'Enter image prefix:'};
        dlg_title = 'Data Naming';
        num_lines = 1;
        defaults = {'image_'};
        answer = inputdlg(prompt,dlg_title,num_lines,defaults);
        
        folder_name = uigetdir('.','Save Folder');
        if(~isnumeric(folder_name))
            number_of_digits=floor(log10(number_of_images))+1;
          
            for img_num=1:number_of_images
                filename=[ folder_name filesep answer{1} sprintf(['%0' num2str(number_of_digits) 'd'],img_num) '.png'];
                imwrite(simucell_result(img_num).RGB_image,filename);
            end
        end
        
    otherwise
        
end


function RespondToEngineWarning(notifier,eventdata)
warndlg(notifier.message);

function RespondToEngineError(notifier,eventdata)
errordlg(notifier.message);

% function setup_simucell_params(hObject, eventdata, handles)
% myhandles=getappdata(0,'myhandles');
% %Overlap assumed to be on cytoplasm(THIS IS JUST WRONG), change this to draw on the overlap menu 
% overlap=Overlap_Specification;
% overlap_areas=cell(0);
% for subpop_num=1:length(myhandles.simucell_data.subpopulations)
%     overlap_areas{subpop_num}=myhandles.simucell_data.subpopulations{subpop_num}.objects.cytoplasm;
% end
% overlap.AddOverlap(overlap_areas,0);
% myhandles.simucell_data.overlap=overlap;
% %Assuming equal subpop-fractions for now, change this to use the GUI params
% myhandles.simucell_data.population_fractions=myhandles.simucell_data.population_fractions';
% %myhandles.simucell_data.population_fractions=ones(length(myhandles.simucell_data.subpopulations),1)/length(myhandles.simucell_data.subpopulations);
% % This needs to use the placement framework
% for subpop_num=1:length(myhandles.simucell_data.subpopulations)
%     myhandles.simucell_data.subpopulations{subpop_num}.placement=Random_Placement();
%     set(myhandles.simucell_data.subpopulations{subpop_num}.placement,'boundary',100);
% end
% % This needs to use the placement framework
% for subpop_num=1:length(myhandles.simucell_data.subpopulations)
%     myhandles.simucell_data.subpopulations{subpop_num}.compositing=Default_Compositing();
%     set(myhandles.simucell_data.subpopulations{subpop_num}.compositing,'container_weight',0);
% end
% %These should be okay
% myhandles.simucell_data.number_of_cells=str2double(get(handles.cellNrEdit,'String'));
% myhandles.simucell_data.simucell_image_size=...
%     [str2double(get(handles.imageWidthEdit,'String')),str2double(get(handles.imageHeightEdit,'String'))];
% setappdata(0,'myhandles',myhandles);


% --- Executes on button press in editColorButton.
function editColorButton_Callback(hObject, eventdata, handles)
% hObject    handle to editColorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in artifactButton.
function artifactButton_Callback(hObject, eventdata, handles)
% hObject    handle to artifactButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
tableData = get(handles.uitable1,'data');
selectedCellPosition = handles.selectedCells;
if(~isempty(selectedCellPosition))
  subpopSelected=tableData{selectedCellPosition(1,1),1};
else
  subpopSelected=1;
end
subpop=myhandles.simucell_data.subpopulations;
if(~isfield(myhandles.simucell_data,'image_artifacts'))
  myhandles.simucell_data.image_artifacts=cell(0);
  setappdata(0,'myhandles',myhandles);
end
image_artifact_list=define_artifact(subpop,subpopSelected,myhandles.simucell_data.image_artifacts);
myhandles.simucell_data.image_artifacts=image_artifact_list;
setappdata(0,'myhandles',myhandles);





% --- Executes on button press in placementButton.
function placementButton_Callback(hObject, eventdata, handles)
% hObject    handle to placementButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');

% tableData = get(handles.uitable1,'data');
% selectedCellPosition = handles.selectedCells;
% if(~isempty(selectedCellPosition))
%   subpopSelected=tableData{selectedCellPosition(1,1),1};
% else
%   subpopSelected=1;
% end
%currentObject=myhandles.simucell_data.subpopulations{subpopSelected}.objects.(objectSelected);
%[simucell_data] = define_placement(myhandles.simucell_data, subpopSelected);
% [overlap_lists overlap_values placement] =...
%   define_placement(myhandles.simucell_data.overlap.overlap_lists,...
%   myhandles.simucell_data.overlap.overlap_values,...
%   myhandles.simucell_data.subpopulations{subpopSelected}.placement,...
%   subpopSelected, myhandles.simucell_data);

if ~isfield(myhandles.simucell_data,'overlap')
  myhandles.simucell_data.overlap=Overlap_Specification;
end

[overlap_lists overlap_values] =...
  define_placement(myhandles.simucell_data.overlap.overlap_lists,...
  myhandles.simucell_data.overlap.overlap_values, myhandles.simucell_data);

if (~isempty(overlap_lists)|| ~isempty(overlap_values))
  myhandles.simucell_data.overlap.overlap_lists=overlap_lists;
  myhandles.simucell_data.overlap.overlap_values=overlap_values;  
%   myhandles.simucell_data.subpopulations{subpopSelected}.placement=placement;  
  setappdata(0,'myhandles',myhandles);
end

% --- Executes on button press in compositingButton.
function compositingButton_Callback(hObject, eventdata, handles)
% hObject    handle to compositingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
tableData = get(handles.uitable1,'data');
selectedCellPosition = handles.selectedCells;
if(~isempty(selectedCellPosition))
  subpopSelected=tableData{selectedCellPosition(1,1),1};
else
  subpopSelected=1;
end
subpopulations =...
  define_compositing(myhandles.simucell_data.subpopulations,...
  subpopSelected);
myhandles.simucell_data.subpopulations=subpopulations;


% --- Executes on button press in cellPlacementButton.
function cellPlacementButton_Callback(hObject, eventdata, handles)
% hObject    handle to cellPlacementButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
tableData = get(handles.uitable1,'data');
selectedCellPosition = handles.selectedCells;
if(~isempty(selectedCellPosition))
  subpopSelected=tableData{selectedCellPosition(1,1),1};
else
  subpopSelected=1;
end
subpopulations =...
  define_cell_placement(myhandles.simucell_data.subpopulations,...
  subpopSelected);
myhandles.simucell_data.subpopulations=subpopulations;
% if (~isempty(overlap_lists)|| ~isempty(overlap_values))
%   myhandles.simucell_data.overlap.overlap_lists=overlap_lists;
%   myhandles.simucell_data.overlap.overlap_values=overlap_values;  
%   myhandles.simucell_data.subpopulations{subpopSelected}.placement=placement;  
%   setappdata(0,'myhandles',myhandles);
% end


% --- Executes on button press in loadButton.
function loadButton_Callback(hObject, eventdata, handles)
% hObject    handle to loadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
{'*.mat','Simucell Parmameters (*.mat)'; '*.*',  'All Files (*.*)'},...
   'Load SimuCell parameters');
if(isnumeric(pathname))%If user pressed cancel button
  return;
end
load([pathname filename],'simucell_data');
myhandles=getappdata(0,'myhandles');
myhandles.simucell_data=simucell_data;
setappdata(0,'myhandles',myhandles);
populateTable(hObject,handles);
myhandles=getappdata(0,'myhandles');
myhandles.simucell_data=populateImageParameters(handles,myhandles.simucell_data);
setappdata(0,'myhandles',myhandles);
