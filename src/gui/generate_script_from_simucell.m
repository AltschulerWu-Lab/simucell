function isSucceed = generate_script_from_simucell(simucell_data,fileName)

%Open the file
fid =fopen(fileName,'w');

if(fid<0)
  isSucceed=false;
  return;
end

%Create the subpopulation
fprintf(fid, '%s\r\n', '%Create Subpopulation Cell Array');
fprintf(fid, '%s\r\n', 'subpop=cell(0);');
%Empty line
fprintf(fid, '%s\r\n', '');
fprintf(fid, '%s\r\n', '');

%For each subpopulation
for i=1:length(simucell_data.subpopulations)
  %Create a new Subpopulation
  fprintf(fid, '%s\r\n', ['%Define Subpopulation ' num2str(i)]);
  fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}=Subpopulation();']);
  
  %Set the Model Placement
  fprintf(fid, '%s\r\n', '%Set the Model Placement');
  placement_type=class(simucell_data.subpopulations{i}.placement);
  fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.placement=' placement_type '();']);
  %Set the Model Placement Parameters 
  subpop=simucell_data.subpopulations{i};
  write_parameters_for_property(fid,...
    simucell_data.subpopulations{i}.placement,...
    ['subpop{' num2str(i) '}.placement'],subpop,['subpop{' num2str(i) '}']);
  
  %Set the Object Shape
  fprintf(fid, '%s\r\n', '%Set the Object Shape');
  %For each object of this subpopulation
  object_list=properties(simucell_data.subpopulations{i}.objects);
  for j=1:length(object_list)
    fprintf(fid, '%s\r\n', ['%Object ' num2str(j)]);
    fprintf(fid, '%s\r\n', ['add_object(subpop{' num2str(i) '},''' object_list{j} ');']);
    object_model=simucell_data.subpopulations{i}.objects.(object_list{j}).model;    
    fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.objects.' object_list{j} '=' class(object_model) ';']);
    property_type=simucell_data.subpopulations{i}.objects.(object_list{j}).model;
    write_parameters_for_property(fid,property_type,['subpop{' num2str(i) '}.objects.' object_list{j}],subpop,['subpop{' num2str(i) '}']);
  end  
  
  %Set the Marker
  fprintf(fid, '%s\r\n', '%Set the Marker');
  %For each marker of this subpopulation
  marker_list=properties(simucell_data.subpopulations{i}.markers);
  for j=1:length(marker_list)
    fprintf(fid, '%s\r\n', ['%Marker ' num2str(j)]);
    fprintf(fid, '%s\r\n', ['add_marker(subpop{' num2str(i) '},''' marker_list{j} ');']);
    
    
    %For each shape of this subpopulation
    shape_list=properties(simucell_data.subpopulations{i}.objects);
    for k=1:length(shape_list)
    %For each operation used to characterize the marker in this shape
      operation_list=simucell_data.subpopulations{i}.markers.(marker_list{j}).(shape_list{k});
      for l=1:length(operation_list)
         operation_name=class(simucell_data.subpopulations{i}.markers.(marker_list{j}).(shape_list{k}).operations{l});
         %Initialize the operation
         fprintf(fid, '%s\r\n', ['op=' operation_name '();']);
         %Set the parameters for this Marker operation
         %TODO FOLLOWING THE NEXT LINE       
         %set(op,'mean_level',0.5,'sd_level',0.1);  
         property_type=simucell_data.subpopulations{i}.objects.(object_list{j}).model;
        write_parameters_for_property(fid,simucell_data.subpopulations{i}.markers.(marker_list{j}).(shape_list{k}).operations{l},'op',subpop,['subpop{' num2str(i) '}']);
         
         %Add the operation
         fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.markers.' marker_list{j} '.' shape_list{k} '.AddOperation(op);']);
      end
    end
    
    
%     marker_model=simucell_data.subpopulations{i}.markers.(marker_list{j}).model;
%     
%     op=Constant_marker_level_operation();
%     set(op,'mean_level',0.5,'sd_level',0.1);
%     subpop{1}.markers.DAPI.cytoplasm.AddOperation(op);
%     op=Constant_dependant_marker_level_operation();
%     set(op,'marker',subpop{1}.markers.DAPI.cytoplasm,'region',subpop{1}.objects.nucleus,'slope',0.5);
%     subpop{1}.markers.DAPI.nucleus.AddOperation(op);
    
    
    
    
    
    fprintf(fid, '%s\r\n', ['add_object(subpop{' num2str(i) '},''' object_list{j} ');']);
    object_model=simucell_data.subpopulations{i}.objects.(object_list{j}).model;    
    fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.objects.' object_list{j} '=' class(object_model) ';']);
    property_type=simucell_data.subpopulations{i}.objects.(object_list{j}).model;
    write_parameters_for_property(fid,property_type,['subpop{' num2str(i) '}.objects.' object_list{j}],subpop,['subpop{' num2str(i) '}'])
  end  
  
  
  
  %Set the Compositing Type
  fprintf(fid, '%s\r\n', '%Set the Composite Type');
  compositing_type=class(simucell_data.subpopulations{i}.compositing);
  fprintf(fid, '%s\r\n', ['subpop{' num2str(i) '}.compositing=' compositing_type '();']);
  %Set the Compositing Parameters
  write_parameters_for_property(fid,...
    simucell_data.subpopulations{i}.compositing,...
    ['subpop{' num2str(i) '}.compositing'],subpop,['subpop{' num2str(i) '}']);
  
  
%Empty line between subpopulation
fprintf(fid, '%s\r\n', '');  
fprintf(fid, '%s\r\n', '');  
end
isSucceed=fclose(fid);

% Write the parameters for a specific property
% property_type:simucell_data.subpopulations{i}.compositing
% property_name:[subpop{' num2str(i) '}.' compositing]
function write_parameters_for_property(fid,property_type,property_name,subpop,subpop_name)  
  %Set the Compositing Parameters
  props=properties(property_type);
  for j=1:length(props)
    if(isa(property_type.(props{j}),'Parameter'));
      value=property_type.(props{j}).value;
      if(isnumeric(value))
        value=num2str(value);
      elseif(isa(value,'SimuCell_Object'))
        shape_name=subpop.find_shape_name(value);
        value=[subpop_name '.objects.' shape_name];
      elseif(isa(value,'Marker_Operation_Queue'))
        [markerName shapeName]=subpop.find_marker_name(value);
        value=[subpop_name '.markers.' markerName '.' shapeName];
      end
      try
        fprintf(fid, '%s\r\n', ['set(' property_name ',''' props{j} ''',' value ');']);
      catch exception
        error('MATLAB:generate_script_from_simucell:write_parameters_for_property', exception);
      end
    end
  end
