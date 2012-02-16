function [a,b,c,d,e]=test_script()
subpop=cell(0);


%subpopulation 1
subpop{1}=Subpopulation();
subpop{1}.placement=Random_Placement();
set(subpop{1}.placement,'boundary',100);

add_object(subpop{1},'cytoplasm');
subpop{1}.objects.cytoplasm.model=Cytoplasm_model;
set(subpop{1}.objects.cytoplasm.model,'radius',30,'eccentricity',0.2);

add_object(subpop{1},'nucleus');
subpop{1}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{1}.objects.nucleus.model,'centered_around',subpop{1}.objects.cytoplasm,'eccentricity',0);

markers1=subpop{1}.markers;

add_marker(subpop{1},'DAPI',Colors.Blue);
op=Constant_marker_level_operation();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_dependant_marker_level_operation();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{1}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{1},'Actin',Colors.Green);
% op=Constant_marker_level_operation();
% set(op,'mean_level',0.7,'sd_level',0.1);
% markers1.Actin.cytoplasm.AddOperation(op);
op=Cell_Density_Dependant_Marker_Level();
set(op,'falloff_type','Linear','falloff_coefficient',10,'increasing_or_decreasing','Decreasing');
markers1.Actin.cytoplasm.AddOperation(op);
op=Angular_marker_gradient();
set(op,'center','Furthest From Edge','falloff_type','Exponential','angular_width',180);
markers1.Actin.cytoplasm.AddOperation(op);

% op=Constant_marker_level_operation();
% set(op,'mean_level',0,'sd_level',0);
% markers1.Actin.nucleus.AddOperation(op);

subpop{1}.compositing=default_compositing();
set(subpop{1}.compositing,'container_weight',0);


%subpopulation 2
subpop{2}=Subpopulation();
subpop{2}.placement=Random_Placement();
set(subpop{2}.placement,'boundary',100);

add_object(subpop{2},'cytoplasm');
subpop{2}.objects.cytoplasm.model=Cytoplasm_model;
set(subpop{2}.objects.cytoplasm.model,'radius',40,'eccentricity',0.2);

add_object(subpop{2},'nucleus');
subpop{2}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{2}.objects.nucleus.model,'centered_around',subpop{2}.objects.cytoplasm,'eccentricity',0);

markers1=subpop{2}.markers;

add_marker(subpop{2},'DAPI',Colors.Blue);
op=Constant_marker_level_operation();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_dependant_marker_level_operation();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{2}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{2},'Actin',Colors.Green);
% op=Constant_marker_level_operation();
% set(op,'mean_level',0.7,'sd_level',0.1);
% markers1.Actin.cytoplasm.AddOperation(op);
op=Cell_Density_Dependant_Marker_Level();
set(op,'falloff_type','Exponential','falloff_coefficient',2,'increasing_or_decreasing','Increasing');
markers1.Actin.cytoplasm.AddOperation(op);


% op=Linear_marker_gradient();
% set(op,'falloff_type','Linear','falloff_coefficient',0.5);
% markers1.Actin.cytoplasm.AddOperation(op);
% op=Distance_to_edge_marker_gradient();
% set(op,'falloff_type','Gaussian','falloff_coefficient',10,'increasing_or_decreasing','Decreasing');
% markers1.Actin.cytoplasm.AddOperation(op);
% op=Distance_to_shape_marker_gradient();
% set(op,'distance_to',subpop{2}.objects.nucleus,'falloff_type','Exponential','falloff_coefficient',2,'increasing_or_decreasing','Decreasing');
% markers1.Actin.cytoplasm.AddOperation(op);


op=Constant_marker_level_operation();
set(op,'mean_level',0,'sd_level',0);
markers1.Actin.nucleus.AddOperation(op);

subpop{2}.compositing=default_compositing();
set(subpop{2}.compositing,'container_weight',0);



overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.05);


op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.2,'blur_radius',5);
subpop{1}.add_cell_artifact(op);
subpop{2}.add_cell_artifact(op);


simucell_data.image_artifacts=cell(0);
op=Add_Basal_Brightness();
set(op,'basal_level',0.15);
simucell_data.image_artifacts{1}=op;
% op=Linear_Image_Gradient();
% simucell_data.image_artifacts{2}=op;
% set(op,'falloff_type','Exponential','falloff_coefficient',0.1);
op=Radial_Image_Gradient();
simucell_data.image_artifacts{2}=op;
set(op,'falloff_type','Sigmoidal','falloff_radius',100);


simucell_data.population_fractions=[1,0];
simucell_data.number_of_cells=15;
simucell_data.simucell_image_size=[500,500];

simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;

[a,b,c,d,e]=SimuCell_Engine(simucell_data);

end