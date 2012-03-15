%% Create Subpopulation Cell Array
subpop=cell(0);


%% Define Subpopulation 1
subpop{1}=Subpopulation();

%% Set the Model Placement
subpop{1}.placement=Random_Placement();
set(subpop{1}.placement,'boundary',100);

%% Set the Object Shape
% Object 1
add_object(subpop{1},'Nuc');
subpop{1}.objects.Nuc.model=Elliptical_nucleus_model;
set(subpop{1}.objects.Nuc.model,'radius',15);
set(subpop{1}.objects.Nuc.model,'eccentricity',0.5);
set(subpop{1}.objects.Nuc.model,'randomness',0.1);
% Object 2
add_object(subpop{1},'Cyto');
subpop{1}.objects.Cyto.model=Elliptical_cytoplasm_model;
set(subpop{1}.objects.Cyto.model,'radius',50);
set(subpop{1}.objects.Cyto.model,'eccentricity',0.7);
set(subpop{1}.objects.Cyto.model,'centered_around',subpop{1}.objects.Nuc);
set(subpop{1}.objects.Cyto.model,'randomness',0.3);

%% Define Markers
% Marker 1
add_marker(subpop{1},'DAPI', Colors.Blue);
% Marker 2
add_marker(subpop{1},'MembMarker', Colors.Red);
% Marker 3
add_marker(subpop{1},'Marker2', Colors.Green);
%% Set Markers Parameters according to the dependencies
%
op=Constant_marker_level_operation();
set(op,'mean_level',0.5);
set(op,'sd_level',0.1);
subpop{1}.markers.DAPI.Nuc.AddOperation(op);
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.2);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.5);
set(op,'noise_type','Standard 1/f');
subpop{1}.markers.DAPI.Nuc.AddOperation(op);
%
op=Constant_marker_level_operation();
set(op,'mean_level',0.7);
set(op,'sd_level',0.2);
subpop{1}.markers.MembMarker.Cyto.AddOperation(op);
op=Distance_to_edge_marker_gradient();
set(op,'falloff_type','Exponential');
set(op,'falloff_radius',4);
set(op,'increasing_or_decreasing','Decreasing');
subpop{1}.markers.MembMarker.Cyto.AddOperation(op);
%
op=Cell_Density_Dependant_Marker_Level();
set(op,'increasing_or_decreasing','Increasing');
set(op,'falloff_radius',40);
set(op,'falloff_type','Gaussian');
set(op,'min_level',0);
set(op,'max_level',1.4);
subpop{1}.markers.Marker2.Cyto.AddOperation(op);
op=Distance_to_shape_marker_gradient();
set(op,'distance_to',subpop{1}.objects.Nuc);
set(op,'falloff_type','Gaussian');
set(op,'falloff_radius',30);
set(op,'increasing_or_decreasing','Decreasing');
subpop{1}.markers.Marker2.Cyto.AddOperation(op);
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.5);
set(op,'length_scale',2);
set(op,'frequency_falloff',1);
set(op,'noise_type','Standard 1/f');
subpop{1}.markers.Marker2.Cyto.AddOperation(op);

%% Set the Composite Type
subpop{1}.compositing=default_compositing();
set(subpop{1}.compositing,'container_weight',0);

%% Set the Cell Artifacts






%% Set Image Parameters
simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;
%Set Number of cell per image
simucell_data.number_of_cells=10;
%Set Image Size
simucell_data.simucell_image_size=[500,500];
%Set Population Fraction
simucell_data.population_fractions=[1];
