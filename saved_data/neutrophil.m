%Create Subpopulation Cell Array
subpop=cell(0);

%% Subpopulation 1

%Define Subpopulation 1
subpop{1}=Subpopulation();

%Set the Model Placement
subpop{1}.placement=Random_Placement();
set(subpop{1}.placement,'boundary',100);

%Set the Composite Type
subpop{1}.compositing=default_compositing();
set(subpop{1}.compositing,'container_weight',0.3);

%% SP1 Shape
%Set the Object Shape
%Object 1
add_object(subpop{1},'cytoplasm');
subpop{1}.objects.cytoplasm.model=Elliptical_nucleus_model;
set(subpop{1}.objects.cytoplasm.model,'radius',40);
set(subpop{1}.objects.cytoplasm.model,'eccentricity',0.01);
set(subpop{1}.objects.cytoplasm.model,'randomness',0.05);

add_object(subpop{1},'nucleus');
subpop{1}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{1}.objects.nucleus.model,'radius',15);
set(subpop{1}.objects.nucleus.model,'eccentricity',0.6);
set(subpop{1}.objects.nucleus.model,'randomness',0.2);
set(subpop{1}.objects.nucleus.model,'centered_around',subpop{1}.objects.cytoplasm);


%% SP1 Markers
%Set the Marker
%Marker 1
add_marker(subpop{1},'Actin','Green');
op=Constant_marker_level_operation();
set(op,'mean_level',0.7);
set(op,'sd_level',0.1);
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
%Add Radial Gradient
op=Distance_to_shape_marker_gradient();
set(op,'falloff_radius',10);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
set(op,'distance_to',subpop{1}.objects.nucleus);
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.3);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.5);
set(op,'noise_type','Turbulent');
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',7);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);


%Marker 2
add_marker(subpop{1},'MT','Red');
op=Constant_marker_level_operation();
set(op,'mean_level',0.9);
set(op,'sd_level',0.1);
subpop{1}.markers.MT.cytoplasm.AddOperation(op);
%Add Radial Gradient
op=Distance_to_edge_marker_gradient();
set(op,'falloff_radius',10);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
subpop{1}.markers.MT.cytoplasm.AddOperation(op);
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.7);
subpop{1}.markers.MT.cytoplasm.AddOperation(op);



% %Marker 3
 add_marker(subpop{1},'DAPI','Blue');
% op=Constant_marker_level_operation();
% set(op,'mean_level',1.0);
% set(op,'sd_level',0.1);
% subpop{1}.markers.DAPI.nucleus.AddOperation(op);
%Cell Density Effect
op=Cell_Density_Dependant_Marker_Level();
%set(op,'amplitude',1000);
set(op,'max_level',2);
set(op,'falloff_radius',200);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
subpop{1}.markers.DAPI.nucleus.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.7);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
% set(op,'noise_type','Turbulent');
subpop{1}.markers.DAPI.nucleus.AddOperation(op);
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.7);
subpop{1}.markers.DAPI.nucleus.AddOperation(op);


op=Constant_dependant_marker_level_operation();
set(op,'slope',-1.2);
set(op,'intercept',0.6);
set(op,'marker',subpop{1}.markers.DAPI.nucleus);
set(op,'region',subpop{1}.objects.nucleus);
subpop{1}.markers.DAPI.cytoplasm.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.4);
set(op,'length_scale',3);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{1}.markers.DAPI.cytoplasm.AddOperation(op);
%% SP1 Rendering
%Set the Cell Artifacts
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',1);
set(op,'blur_radius',2);
subpop{1}.add_cell_artifact(op);
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.1);
set(op,'blur_radius',4);
subpop{1}.add_cell_artifact(op);

%% Subpopulation 2

%Define Subpopulation 1
subpop{2}=Subpopulation();

%Set the Model Placement
subpop{2}.placement=Random_Placement();
set(subpop{2}.placement,'boundary',100);

%Set the Composite Type
subpop{2}.compositing=default_compositing();
set(subpop{2}.compositing,'container_weight',0.3);

%% SP2 Shape
%Set the Object Shape
%Object 1
add_object(subpop{2},'cytoplasm');
subpop{2}.objects.cytoplasm.model=Elliptical_nucleus_model;
set(subpop{2}.objects.cytoplasm.model,'radius',60);
set(subpop{2}.objects.cytoplasm.model,'eccentricity',0.6);
set(subpop{2}.objects.cytoplasm.model,'randomness',0.2);

add_object(subpop{2},'nucleus');
subpop{2}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{2}.objects.nucleus.model,'radius',10);
set(subpop{2}.objects.nucleus.model,'eccentricity',0.6);
set(subpop{2}.objects.nucleus.model,'randomness',0.2);
set(subpop{2}.objects.nucleus.model,'centered_around',subpop{2}.objects.cytoplasm);


%% SP2 Markers
%Set the Marker
%Marker 1
add_marker(subpop{2},'MT','Red');
op=Constant_marker_level_operation();
set(op,'mean_level',0.8);
set(op,'sd_level',0.1);
subpop{2}.markers.MT.cytoplasm.AddOperation(op);
%Add Radial Gradient
op=Angular_marker_gradient();
set(op,'center','Furthest From Edge');
set(op,'angular_width',30);
set(op,'falloff_type','Exponential');
set(op,'min_multiplier',0);
subpop{2}.markers.MT.cytoplasm.AddOperation(op);
%Add Radial Gradient
op=Distance_to_edge_marker_gradient();
set(op,'falloff_radius',15);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
subpop{2}.markers.MT.cytoplasm.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.5);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{2}.markers.MT.cytoplasm.AddOperation(op);
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.8);
subpop{2}.markers.MT.cytoplasm.AddOperation(op);
%Marker Rescaling
% op=Rescale_marker_levels_operation();
% set(op,'min_intensity',0);
% set(op,'max_intensity',1);
% subpop{2}.markers.MT.cytoplasm.AddOperation(op);


%Marker 2
add_marker(subpop{2},'Actin','Green');
op=Locally_dependant_marker_level_operation();
set(op,'slope',-100);
set(op,'intercept',0.8);
set(op,'marker',subpop{2}.markers.MT.cytoplasm);
subpop{2}.markers.Actin.cytoplasm.AddOperation(op);
%Add Radial Gradient
op=Distance_to_edge_marker_gradient();
set(op,'falloff_radius',40);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Increasing');
subpop{2}.markers.Actin.cytoplasm.AddOperation(op);
op=Perlin_Texture();
set(op,'amplitude',0.3);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{2}.markers.Actin.cytoplasm.AddOperation(op)
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.5);
subpop{2}.markers.Actin.cytoplasm.AddOperation(op);


%Marker 3
 add_marker(subpop{2},'DAPI','Blue');
% op=Constant_marker_level_operation();
% set(op,'mean_level',1.0);
% set(op,'sd_level',0.1);
% subpop{2}.markers.DAPI.nucleus.AddOperation(op);
%Cell Density Effect
op=Cell_Density_Dependant_Marker_Level();
set(op,'max_level',2);
set(op,'falloff_radius',200);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
subpop{2}.markers.DAPI.nucleus.AddOperation(op);
%Perlin Texture
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.7);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
% set(op,'noise_type','Turbulent');
subpop{2}.markers.DAPI.nucleus.AddOperation(op);


op=Constant_dependant_marker_level_operation();
set(op,'slope',-1.2);
set(op,'intercept',0.6);
set(op,'marker',subpop{2}.markers.DAPI.nucleus);
set(op,'region',subpop{2}.objects.nucleus);
subpop{2}.markers.DAPI.cytoplasm.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.4);
set(op,'length_scale',3);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{2}.markers.DAPI.cytoplasm.AddOperation(op);

%% SP2 Rendering
%Set the Cell Artifacts
% op=Out_Of_Focus_Cells();
% set(op,'fraction_blurred',1);
% set(op,'blur_radius',2);
% subpop{2}.add_cell_artifact(op);
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.1);
set(op,'blur_radius',4);
%subpop{2}.add_cell_artifact(op);

%% Common to all subpops
overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.05);

%simucell_data.image_artifacts=cell(0);
%op=Add_Basal_Brightness();
%set(op,'basal_level',0.1);
%simucell_data.image_artifacts{1}=op;
% op=Radial_Image_Gradient();
% simucell_data.image_artifacts{2}=op;
% set(op,'falloff_type','Sigmoidal','falloff_radius',200);

simucell_data.population_fractions=[1 0];
simucell_data.number_of_cells=7;
simucell_data.simucell_image_size=[700,700];

simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;
% 
% [obv_del,all_del]=simucell_data.subpopulations{1}.calculate_all_dependancies(...
%     simucell_data.subpopulations{1}.objects.lipid_droplets);
% 
% [obv_del,all_del]=simucell_data.subpopulations{1}.calculate_all_dependancies(...
%     simucell_data.subpopulations{1}.markers.MT);
% 
[a,b,c,d,e]=SimuCell_Engine(simucell_data);image(a);axis off; axis equal;

