function varargout = define_placement(varargin)
% DEFINE_PLACEMENT MATLAB code for define_placement.fig
%      DEFINE_PLACEMENT, by itself, creates a new DEFINE_PLACEMENT or raises the existing
%      singleton*.
%
%      H = DEFINE_PLACEMENT returns the handle to a new DEFINE_PLACEMENT or the handle to
%      the existing singleton*.
%
%      DEFINE_PLACEMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFINE_PLACEMENT.M with the given input arguments.
%
%      DEFINE_PLACEMENT('Property','Value',...) creates a new DEFINE_PLACEMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before define_placement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to define_placement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help define_placement

% Last Modified by GUIDE v2.5 10-Mar-2012 12:18:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @define_placement_OpeningFcn, ...
                   'gui_OutputFcn',  @define_placement_OutputFcn, ...
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


% --- Executes just before define_placement is made visible.
function define_placement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to define_placement (see VARARGIN)

% Choose default command line output for define_placement
handles.output = hObject;
if (length(varargin) < 3) %|| ~isa(varargin{1}, 'importantObjectType')
     error ('you must pass your simucell_data and subpopulation nr');
end
placementHandles.overlap_lists = varargin{1};
placementHandles.overlap_values = varargin{2};
if(isempty(placementHandles.overlap_values))
    placementHandles.overlap_values=[];
end
% placementHandles.placement = varargin{3};
% subpop_nr =  varargin{4};
placementHandles.simucell_data =  varargin{3};
setappdata(0,'placementHandles',placementHandles);

% %Populate the subpopulation Combo Box
% subpopNr=length(placementHandles.simucell_data.subpopulations);
% set(handles.subpopNrCB,'String',num2cell(1:subpopNr),'Value',subpop_nr);
% %Populate the Placement ComboBox list (just once)
% fileList=dir('plugins/placement/');
% fileList = {fileList(find([fileList.isdir]==0)).name};
% for i=1:length(fileList)
%   fileList{i}=fileList{i}(1:end-2);
% end
% set(handles.placementCB,'String',fileList);
% %Set the Cell placement type for the selected subpopulation
% populateCellPlacementType(subpop_nr,handles);
%Populate the Overlap list
overlapListSize=length(placementHandles.simucell_data.overlap.overlap_lists);
if(overlapListSize==0)
  overlapListSize=1;
end
set(handles.overlapListCB,'String',num2cell(1:overlapListSize),'Value',1);
%Populate the Overlap Rule Object list of choice (do it once only)
index=1;
objectPopList=[];
for j=1:length(placementHandles.simucell_data.subpopulations)
  objectList=properties(placementHandles.simucell_data.subpopulations{j}.objects);
  for k=1:length(objectList)
    objectPopList{index}=['subpop#' num2str(j) ' - ' objectList{k}];
    index=index+1;
  end
end
if(~isempty(objectPopList))
  set(handles.objectListCB,'String',objectPopList);
  %Populate the Overlap rule list parameters
  populateCellOverlapParam(1,handles);
end
guidata(hObject, handles);
%Wait until GUI get close 
uiwait(handles.figure1);

function populateCellOverlapParam(overlapRuleNr,handles)
placementHandles=getappdata(0,'placementHandles');
%Set the Cell Overlapping object list and Overlap Max area Value
if(isfield(placementHandles,'overlap_lists'))
 %Set Overlap Max area Value
 if(~isempty(placementHandles.overlap_values))
  set(handles.maxOverlappingEdit,'String',...
    num2str(placementHandles.overlap_values(overlapRuleNr)*100));
 end
 %Set Cell Overlapping object list
 objectSelectedList=[];
 index=1;
 if length(placementHandles.overlap_lists)>0
   for i=1:length(placementHandles.overlap_lists{overlapRuleNr})
     for j=1:length(placementHandles.simucell_data.subpopulations)
      objectName=placementHandles.simucell_data.subpopulations{j}.find_shape_name(placementHandles.overlap_lists{overlapRuleNr}{i});
      if(~isempty(objectName))
        objectSelectedList{index}=['subpop#' num2str(j) ' - ' objectName];
        index=index+1;
      end
     end
   end
 end
 set(handles.objectListBox,'String',objectSelectedList,'Value',1);
end

function populateCellPlacementType(subpopNr,handles)
%Next 2 lines need to be done only once
dirList=dir(['plugins' filesep 'placement' filesep '*.m']);
dirList=dirList(3:end);
placementHandles=getappdata(0,'placementHandles');
    %Set the Cell placement type for the selected subpopulation
if(~isempty(placementHandles.placement));
  currentClassName=class(placementHandles.placement);
  selectedPlacement=currentClassName;
end
if(~isempty(selectedPlacement))
   valueSelected=find(strcmp(dirList.name, [selectedPlacement '.m']));
   %Set the Placement Type
   set(handles.placementCB,'Value',valueSelected);
end

% --- Outputs from this function are returned to the command line.
function varargout = define_placement_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
placementHandles=getappdata(0,'placementHandles');
varargout{1}=placementHandles.overlap_lists;
varargout{2}=placementHandles.overlap_values;
%varargout{3}=placementHandles.placement;
if(~isempty(handles))
  delete(handles.figure1);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in objectListCB.
function objectListCB_Callback(hObject, eventdata, handles)
% hObject    handle to objectListCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns objectListCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from objectListCB


% --- Executes during object creation, after setting all properties.
function objectListCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objectListCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addObjectButton.
function addObjectButton_Callback(hObject, eventdata, handles)
% hObject    handle to addObjectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Get the overlap rule nr selected
placementHandles=getappdata(0,'placementHandles');
overlapRuleNr=get(handles.overlapListCB,'Value');

selectedObjectList=get(handles.objectListCB,'String');
selectedObjectValue=get(handles.objectListCB,'Value');
selectedObject=selectedObjectList{selectedObjectValue};
%get the Object selected
previousSelectedObjectList=get(handles.objectListBox,'String');
%Check if is not already used:
if ~isempty(find(strcmp(previousSelectedObjectList, selectedObject)))
  warndlg('This object has already been added to this rule list!');
  return;
end
%Get the objectName and subpopulation number
[~,~,~,~,~, tokenname,~]=regexp(selectedObject,'subpop#(?<subpopNr>[0-9]{1,3}) - (?<objectName>[a-zA-Z]*)');
objectName=tokenname.objectName;
subpopNr=str2double(tokenname.subpopNr);
%Get the selected object to add
addedObject=placementHandles.simucell_data.subpopulations{subpopNr}.objects.(objectName);
if(~isempty(placementHandles.overlap_lists))
  %Get the number of object present in the list
  nrObjectInList=length(placementHandles.overlap_lists{overlapRuleNr});
  %Add the object to the overlap list
  %placementHandles.simucell_data.overlap.overlap_lists{overlapRuleNr}{nrObjectInList+1}=addedObject;
  placementHandles.overlap_lists{overlapRuleNr}{nrObjectInList+1}=addedObject;
else
  placementHandles.overlap_lists{overlapRuleNr}{1}=addedObject;
end
setappdata(0,'placementHandles',placementHandles);
%Re-populate the list of overlap rule for the selected rule list
populateCellOverlapParam(overlapRuleNr,handles);


% --- Executes on selection change in objectListBox.
function objectListBox_Callback(hObject, eventdata, handles)
% hObject    handle to objectListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns objectListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from objectListBox


% --- Executes during object creation, after setting all properties.
function objectListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to objectListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in removeObjectButton.
function removeObjectButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeObjectButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
placementHandles=getappdata(0,'placementHandles');
overlapRuleNr=get(handles.overlapListCB,'Value');
selectedObjectValue=get(handles.objectListBox,'Value');
placementHandles.overlap_lists{overlapRuleNr}=...
  removeFromCellArray(placementHandles.overlap_lists{overlapRuleNr},...
  selectedObjectValue);
setappdata(0,'placementHandles',placementHandles);
%Re-populate the list of overlap rule for the selected rule list
populateCellOverlapParam(overlapRuleNr,handles);


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


% --- Executes on selection change in placementCB.
function placementCB_Callback(hObject, eventdata, handles)
% hObject    handle to placementCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns placementCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from placementCB


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


function savePlacementButton_Callback(hObject, eventdata, handles)
% hObject    handle to savePlacementButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
placementHandles=getappdata(0,'placementHandles');
placementType=get(handles.placementCB,'String');
placementHandles.placement=eval(placementType{1});
%Set the Cell placement type for the selected subpopulation
populateCellPlacementType(subpop_nr,handles);
setappdata(0,'placementHandles',placementHandles);


% --- Executes on button press in cancelButton.
function cancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to cancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
placementHandles=getappdata(0,'placementHandles');
placementHandles.overlap_lists=[];
placementHandles.overlap_values=[];
placementHandles.placement=[];  
setappdata(0,'placementHandles',placementHandles);
uiresume;

% --- Executes on button press in backButton.
function backButton_Callback(hObject, eventdata, handles)
% hObject    handle to backButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
placementHandles=getappdata(0,'placementHandles');
setappdata(0,'placementHandles',placementHandles);
uiresume;



function maxOverlappingEdit_Callback(hObject, eventdata, handles)
% hObject    handle to maxOverlappingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxOverlappingEdit as text
%        str2double(get(hObject,'String')) returns contents of maxOverlappingEdit as a double


% --- Executes during object creation, after setting all properties.
function maxOverlappingEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxOverlappingEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in overlapListCB.
function overlapListCB_Callback(hObject, eventdata, handles)

% hObject    handle to overlapListCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns overlapListCB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from overlapListCB
overlapRuleNr=get(handles.overlapListCB,'Value');
populateCellOverlapParam(overlapRuleNr,handles);


% --- Executes during object creation, after setting all properties.
function overlapListCB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to overlapListCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveRuleDefinition.
function saveRuleDefinition_Callback(hObject, eventdata, handles)
placementHandles=getappdata(0,'placementHandles');
overlapRuleNr=get(handles.overlapListCB,'Value');
overlappingValue=get(handles.maxOverlappingEdit,'String');
placementHandles.overlap_values(overlapRuleNr)=str2double(overlappingValue)/100;
setappdata(0,'placementHandles',placementHandles);


% --- Executes on button press in addRuleButton.
function addRuleButton_Callback(hObject, eventdata, handles)
% hObject    handle to addRuleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
placementHandles=getappdata(0,'placementHandles');
placementHandles.overlap_lists{length(placementHandles.overlap_lists)+1}={};
setappdata(0,'placementHandles',placementHandles);

overlapListSize=length(placementHandles.overlap_lists);
if(overlapListSize==0)
  overlapListSize=1;
end
set(handles.overlapListCB,'String',num2cell(1:overlapListSize),'Value',1);


% --- Executes on button press in removeRuleButton.
function removeRuleButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeRuleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
placementHandles=getappdata(0,'placementHandles');
ruleNr=get(handles.overlapListCB,'Value');
placementHandles.overlap_lists=removeFromCellArray(placementHandles.overlap_lists,ruleNr);
setappdata(0,'placementHandles',placementHandles);
overlapListSize=length(placementHandles.overlap_lists);
set(handles.overlapListCB,'String',num2cell(1:overlapListSize),'Value',1);
