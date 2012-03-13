%% Create Subpopulation Cell Array
subpop=cell(0);


%% Define Subpopulation 1
subpop{1}=Subpopulation();

%% Set the Model Placement
subpop{1}.placement=Nearby_Placement();
set(subpop{1}.placement,'distance_to_existing',15);
set(subpop{1}.placement,'boundary',100);
set(subpop{1}.placement,'clustering_probability',0.8);

%% Set the Object Shape
% Object 1
add_object(subpop{1},'cytoplasm');
subpop{1}.objects.cytoplasm.model=Cytoplasm_model;
set(subpop{1}.objects.cytoplasm.model,'radius',40);
set(subpop{1}.objects.cytoplasm.model,'eccentricity',0.7);
set(subpop{1}.objects.cytoplasm.model,'randomness',0.3);
% Object 2
add_object(subpop{1},'nucleus');
subpop{1}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{1}.objects.nucleus.model,'radius',15);
set(subpop{1}.objects.nucleus.model,'eccentricity',0.7);
set(subpop{1}.objects.nucleus.model,'centered_around',subpop{1}.objects.cytoplasm);
set(subpop{1}.objects.nucleus.model,'randomness',0.2);

%% Define Markers
% Marker 1
add_marker(subpop{1},'menv', Colors.Red);
% Marker 2
add_marker(subpop{1},'GFP', Colors.Green);
% Marker 3
add_marker(subpop{1},'DAPI', Colors.Blue);
%% Set Markers Parameters according to the dependencies
%%%%%% Microenvironment dependant marker
op=Microenvironmental_Marker_Level();
set(op,'length_scale',3);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{1}.markers.menv.cytoplasm.AddOperation(op);
op=Distance_to_edge_marker_gradient();
set(op,'falloff_type','Exponential');
set(op,'falloff_radius',10);
set(op,'increasing_or_decreasing','Decreasing');
subpop{1}.markers.menv.cytoplasm.AddOperation(op);
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.2);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{1}.markers.menv.cytoplasm.AddOperation(op);
% op=Turbulent_Texture();
% set(op,'max_displacement',3);
% set(op,'length_scale',4);
% set(op,'frequency_falloff',0.9);
% set(op,'smooth_edges','No');
% subpop{1}.markers.menv.cytoplasm.AddOperation(op);


%%%%%% GFP
op=Constant_dependant_marker_level_operation();
set(op,'slope',-2.5);
set(op,'intercept',0.9);
set(op,'marker',subpop{1}.markers.menv.cytoplasm);
set(op,'region',subpop{1}.objects.cytoplasm);
set(op,'func','Mean');
subpop{1}.markers.GFP.cytoplasm.AddOperation(op);
op=Constant_marker_level_operation();
set(op,'mean_level',0.5);
set(op,'sd_level',0.2);
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.1);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.7);
set(op,'noise_type','Turbulent');
subpop{1}.markers.GFP.cytoplasm.AddOperation(op);

%%%%%% DAPI
op=Constant_marker_level_operation();
set(op,'mean_level',0.5);
set(op,'sd_level',0.2);
subpop{1}.markers.DAPI.nucleus.AddOperation(op);
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.3);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.7);
set(op,'noise_type','Standard 1/f');
subpop{1}.markers.DAPI.nucleus.AddOperation(op);

%% Set the Composite Type
subpop{1}.compositing=default_compositing();
set(subpop{1}.compositing,'container_weight',0);

%% Set the Cell Artifacts
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',1);
set(op,'blur_radius',2);
%subpop{1}.add_cell_artifact(op);


%% Set Overlap
overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm},0);


%% Set Image Artifact
simucell_data.image_artifacts=cell(0);
op=Radial_Image_Gradient();
set(op,'falloff_type','Gaussian');
set(op,'falloff_radius',5);
set(op,'max_multiplier',1.5);
set(op,'min_multiplier',0.5);
simucell_data.image_artifacts{1}=op;


%% Set Image Parameters
simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;
%Set Number of cell per image
simucell_data.number_of_cells=100;
%Set Image Size
simucell_data.simucell_image_size=[1000,1000];
%Set Population Fraction
simucell_data.population_fractions=[1];
[a,b,c,d,e]=SimuCell_Engine(simucell_data);image(a);axis off; axis equal;
