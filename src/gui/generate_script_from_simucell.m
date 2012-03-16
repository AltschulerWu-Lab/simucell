function isSucceed = generate_script_from_simucell(simucell_data,fileName)

%Open the file
fid =fopen(fileName,'w');

if(fid<0)
  isSucceed=false;
  return;
end

%Create the subpopulation
fprintf(fid, '%s\r\n', '%% Create Subpopulation Cell Array');
fprintf(fid, '%s\r\n', 'subpop=cell(0);');
%Empty line
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '');

%For each subpopulation
for i=1:length(simucell_data.subpopulations)
  %Create a new Subpopulation
  fprintf(fid, '%s\r\n', ['%% Define Subpopulation ' num2str(i)]);
  fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}=Subpopulation();']);
  
  %Set the Model Placement
  %Empty line
  fprintf(fid, '%s\r\n', '');  
  fprintf(fid, '%s\r\n', '%% Set the Model Placement');
  placement_type=class(simucell_data.subpopulations{i}.placement);
  fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.placement=' placement_type '();']);
  %Set the Model Placement Parameters 
  subpop=simucell_data.subpopulations{i};
  write_parameters_for_property(fid,...
    simucell_data.subpopulations{i}.placement,...
    ['subpop{' num2str(i) '}.placement'],subpop,['subpop{' num2str(i) '}']);

  %Empty line
  fprintf(fid, '%s\r\n', '');  
  %Set the Object Shape
  fprintf(fid, '%s\r\n', '%% Set the Object Shape');
  simucell_data.subpopulations{i}.calculate_shape_draw_order();
  object_list=simucell_data.subpopulations{i}.object_draw_order;
  for j=1:length(object_list)
    fprintf(fid, '%s\r\n', ['% Object ' num2str(j)]);
    fprintf(fid, '%s\r\n', ['add_object(subpop{' num2str(i) '},''' object_list{j} ''');']);
    object_model=simucell_data.subpopulations{i}.objects.(object_list{j}).model;    
    fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.objects.' object_list{j} '.model=' class(object_model) ';']);
    property_type=simucell_data.subpopulations{i}.objects.(object_list{j}).model;
    write_parameters_for_property(fid,property_type,['subpop{' num2str(i) '}.objects.' object_list{j}],subpop,['subpop{' num2str(i) '}']);
  end  
  
  %Empty line
  fprintf(fid, '%s\r\n', '');  
  %Set the Marker
  fprintf(fid, '%s\r\n', '%% Define Markers');  
  %For each marker of this subpopulation Create it
  marker_list=properties(simucell_data.subpopulations{i}.markers);
  for j=1:length(marker_list)
    color=simucell_data.subpopulations{i}.markers.(marker_list{j}).color.char;
    fprintf(fid, '%s\r\n', ['% Marker ' num2str(j)]);
    fprintf(fid, '%s\r\n',...
      ['add_marker(subpop{' num2str(i) '},''' marker_list{j} ''', Colors.' color  ');']);   
  end
  
  fprintf(fid, '%s\r\n', '%% Set Markers Parameters according to the dependencies');
  %Then for all the couple Marker/Shape, add the operations
  simucell_data.subpopulations{i}.calculate_marker_draw_order();
  marker_shape_list=simucell_data.subpopulations{i}.marker_draw_order_names;
  for j=1:length(marker_shape_list)
%     fprintf(fid, '%s\r\n', ['%Marker ' num2str(j)]);
     markerName=marker_shape_list{j}{1,1};
     shapeName=marker_shape_list{j}{1,2};
    operation_list=simucell_data.subpopulations{i}.markers.(markerName).(shapeName);
    for l=1:length(operation_list.operations)
      operation_name=class(simucell_data.subpopulations{i}.markers.(markerName).(shapeName).operations{l});
      %Initialize the operation
      fprintf(fid, '%s\r\n', ['op=' operation_name '();']);
      %Set the parameters for this Marker operation
      property_type=simucell_data.subpopulations{i}.markers.(markerName).(shapeName).operations{l};
      write_parameters_for_property(fid,property_type,'op',...
        subpop,['subpop{' num2str(i) '}']);
      %Add the Operation
      fprintf(fid, '%s\r\n',...
        ['subpop{' num2str(i) '}.markers.'...
        markerName '.' shapeName '.AddOperation(op);']);
    end
    %end
  end 
  
  %Empty line
  fprintf(fid, '%s\r\n', '');  
  %Set the Compositing Type
  fprintf(fid, '%s\r\n', '%% Set the Composite Type');
  compositing_type=class(simucell_data.subpopulations{i}.compositing);
  fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.compositing=' compositing_type '();']);
  %Set the Compositing Parameters
  write_parameters_for_property(fid,...
    simucell_data.subpopulations{i}.compositing,...
    ['subpop{' num2str(i) '}.compositing'],subpop,['subpop{' num2str(i) '}']);
  
  %Empty line
  fprintf(fid, '%s\r\n', '');  
  %Set the Cell Artifacts
  fprintf(fid, '%s\r\n', '%% Set the Cell Artifacts');
  for j=1:length(simucell_data.subpopulations{i}.cell_artifacts)
    operation_name=class(simucell_data.subpopulations{i}.cell_artifacts{j});
    %Initialize the operation
    fprintf(fid, '%s\r\n', ['op=' operation_name '();']);
    %Set the parameters for this Cell Artifacts operation
    property_type=simucell_data.subpopulations{i}.cell_artifacts{j};
    write_parameters_for_property(fid,property_type,'op',...
      subpop,['subpop{' num2str(i) '}']);
    %Add the Operation
    fprintf(fid, '%s\r\n',...
      ['subpop{' num2str(i) '}' '.add_cell_artifact(op);']);
  end
  
%Empty lines between subpopulation
fprintf(fid, '%s\r\n', '');  
fprintf(fid, '%s\r\n', '');  
end


%Set the Overlapp
if(isfield(simucell_data,'overlap') &&...
  ~isempty(simucell_data.overlap.overlap_lists))
  fprintf(fid, '%s\r\n', '%% Set Overlap');
  for i=1:length(simucell_data.overlap.overlap_lists)
    fprintf(fid, '%s\r\n', 'overlap=Overlap_Specification;');
    command='overlap.AddOverlap({';
    for j=1:size(simucell_data.overlap.overlap_lists{i},2)
      %Get the shape name and subpopulation associated
      subpopNr=[];
      shapeName=[];
      shapeObj=simucell_data.overlap.overlap_lists{i}{j};
      for k=1:length(simucell_data.subpopulations)
        if(~isempty(simucell_data.subpopulations{k}.find_shape_name(shapeObj)))
          shapeName=simucell_data.subpopulations{k}.find_shape_name(shapeObj);
          subpopNr=k;
          command=[command 'subpop{' num2str(subpopNr) '}.objects.' shapeName ','];
          break;
        end
      end
    end
    command=command(1:end-1);
    if(length(simucell_data.overlap.overlap_lists)==1)
      overlapParam=simucell_data.overlap.overlap_values;
    else
      overlapParam=simucell_data.overlap.overlap_values{i};
    end
    command =[command '},' num2str(overlapParam) ');'];
    fprintf(fid, '%s\r\n', command);
  end
end

%Empty lines
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '');

%Set Images Artifact
if(isfield(simucell_data,'image_artifacts') &&...
  ~isempty(simucell_data.image_artifacts))
  fprintf(fid, '%s\r\n', '%% Set Image Artifact');
  fprintf(fid, '%s\r\n', 'simucell_data.image_artifacts=cell(0);');
  for i=1:length(simucell_data.image_artifacts)
    operation_name=class(simucell_data.image_artifacts{i});
    %Initialize the operation
    fprintf(fid, '%s\r\n', ['op=' operation_name '();']);
    %Set the parameters for this Image Artifacts operation
    property_type=simucell_data.image_artifacts{i};
    write_parameters_for_property(fid,property_type,'op',...
      subpop,['subpop{' num2str(i) '}']);
    fprintf(fid, '%s\r\n', ['simucell_data.image_artifacts{' num2str(i) '}=op;']);
  end
end

%Empty lines
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '');

fprintf(fid, '%s\r\n', '%% Set Image Parameters');
%Set the main structure name and add the subpopulation field and overlap
fprintf(fid, '%s\r\n', 'simucell_data.subpopulations=subpop;');
if(isfield(simucell_data,'overlap') &&...
  ~isempty(simucell_data.overlap.overlap_lists))
  fprintf(fid, '%s\r\n', 'simucell_data.overlap=overlap;');
end
%Set Image Parameters
fprintf(fid, '%s\r\n', '%Set Number of cell per image');
fprintf(fid, '%s\r\n', ['simucell_data.number_of_cells=' num2str(simucell_data.number_of_cells) ';']);
fprintf(fid, '%s\r\n', '%Set Image Size');
fprintf(fid, '%s\r\n',['simucell_data.simucell_image_size=['...
  num2str(simucell_data.simucell_image_size(1,1))...
  ',' num2str(simucell_data.simucell_image_size(1,2)) '];']);
fprintf(fid, '%s\r\n', '%Set Population Fraction');
fprintf(fid, '%s', 'simucell_data.population_fractions=[');
for i=1:length(simucell_data.population_fractions)
  if(i<length(simucell_data.population_fractions))
    fprintf(fid, '%s', [num2str(simucell_data.population_fractions(i)) ',']);
  else
    fprintf(fid, '%s\r\n', [num2str(simucell_data.population_fractions(i)) '];']);    
  end
end
isSucceed=fclose(fid);


%% Write the parameters for a specific property
% property_type:simucell_data.subpopulations{i}.compositing
% property_name:[subpop{' num2str(i) '}.' compositing]
function write_parameters_for_property(fid,property_type,property_name,subpop,subpop_name)  
  %Set the Compositing Parameters
  props=properties(property_type);
  if(isa(property_type,'SimuCell_Object_Model'))
    property_name=[property_name '.model'];
  end
  for j=1:length(props)
    if(isa(property_type.(props{j}),'Parameter'));
      value=property_type.(props{j}).value;
      if(isa(value,'SimuCell_Class_Type.list'))
        value=num2str(value);
      elseif(isnumeric(value))
        value=num2str(value);
      elseif(isa(value,'SimuCell_Object'))
        shape_name=subpop.find_shape_name(value);
        value=[subpop_name '.objects.' shape_name];
      elseif(isa(value,'Marker_Operation_Queue'))
        [markerName shapeName]=subpop.find_marker_name(value);
        value=[subpop_name '.markers.' markerName '.' shapeName];
      else
        value=['''' value ''''];
      end
      try
        fprintf(fid, '%s\r\n', ['set(' property_name ',''' props{j} ''',' value ');']);
      catch exception
        error('MATLAB:generate_script_from_simucell:write_parameters_for_property', exception);
      end
    end
  end
