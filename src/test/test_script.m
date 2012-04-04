function [a,b,c,d,e]=test_script()
subpop=cell(0);


%subpopulation 1
subpop{1}=Subpopulation();
subpop{1}.placement=Random_Placement();
% subpop{1}.placement=Clustered_Placement();
% set(subpop{1}.placement,'boundary',100,'cluster_width',100);


add_object(subpop{1},'nucleus');
subpop{1}.objects.nucleus.model=Nucleus_Model;
set(subpop{1}.objects.nucleus.model,'radius',15,'eccentricity',0.7);

%add_object(subpop{1},'nucleus');
% subpop{1}.objects.nucleus.model=SLML_Nucleus_Model;
%set(subpop{1}.objects.nucleus.model,'radius',30);
%set(subpop{1}.objects.nucleus.model,'radius',30,...
%    'filename','/home/srajaram/Work/Code/SimuCell/Code/src/test/test_slml/endosome.mat');

add_object(subpop{1},'cytoplasm');
subpop{1}.objects.cytoplasm.model=Centered_Cytoplasm_Model;
set(subpop{1}.objects.cytoplasm.model,'radius',60,'eccentricity',0.9,'randomness',0.3,'centered_around',subpop{1}.objects.nucleus);


add_object(subpop{1},'lipid_droplets');
subpop{1}.objects.lipid_droplets.model=Lipid_Droplet_Model;
set(subpop{1}.objects.lipid_droplets.model,'droplet_radius',5,...
    'number_of_droplets',5,'number_of_clusters',2,...
    'nucleus',subpop{1}.objects.nucleus);


set(subpop{1}.objects.lipid_droplets.model,'droplet_radius',5,...
    'number_of_droplets',5,'number_of_clusters',2,...
    'nucleus',subpop{1}.objects.nucleus,'cytoplasm',subpop{1}.objects.cytoplasm);


add_object(subpop{1},'fiber');
subpop{1}.objects.fiber.model=Microtubule_Fibre_Model;
set(subpop{1}.objects.fiber.model,'nucleus',subpop{1}.objects.nucleus,...
    'cytoplasm',subpop{1}.objects.cytoplasm);

% add_object(subpop{1},'cytoplasm');
% subpop{1}.objects.cytoplasm.model=Cytoplasm_Model;
% set(subpop{1}.objects.cytoplasm.model,'radius',30,'eccentricity',0.2);
% 
% add_object(subpop{1},'nucleus');
% subpop{1}.objects.nucleus.model=Centered_Nucleus_Model;
% set(subpop{1}.objects.nucleus.model,'centered_around',subpop{1}.objects.cytoplasm,'eccentricity',0);

markers1=subpop{1}.markers;

add_marker(subpop{1},'DAPI',Colors.Blue);
op=Constant_Marker_Level();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.nucleus.AddOperation(op);
op=Perlin_Texture();
set(op,'length_scale',4,'frequency_falloff',1,'amplitude',0.25);
markers1.DAPI.nucleus.AddOperation(op);
% op=Constant_Marker_Level();
% set(op,'mean_level',0.5,'sd_level',0.1);
% markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_Dependant_Marker_Level();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{1}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{1},'Actin',Colors.Green);
op=Constant_Marker_Level();
set(op,'mean_level',0.1,'sd_level',0);
markers1.Actin.cytoplasm.AddOperation(op);
% op=Perlin_Texture();
% markers1.Actin.cytoplasm.AddOperation(op);
% op=Cell_Density_Dependant_Marker_Level();
% set(op,'falloff_type','Linear','falloff_coefficient',10,'increasing_or_decreasing','Decreasing');
% markers1.Actin.cytoplasm.AddOperation(op);
% op=Angular_Marker_Gradient();
% set(op,'center','Furthest From Edge','falloff_type','Exponential','angular_width',180);
% markers1.Actin.cytoplasm.AddOperation(op);
op=Perlin_Texture();
markers1.Actin.cytoplasm.AddOperation(op);
op=Constant_Marker_Level();
set(op,'mean_level',0.8,'sd_level',0.1);
markers1.Actin.lipid_droplets.AddOperation(op);
%op=Turbulent_Texture();
%markers1.Actin.cytoplasm.AddOperation(op);

% op=Constant_Dependant_Marker_Level();
% set(op,'slope',-1,'intercept',0.5,'marker',markers1.Actin.cytoplasm,'region',subpop{1}.objects.cytoplasm);
% markers1.Actin.nucleus.AddOperation(op);


add_marker(subpop{1},'MT',Colors.Red);
op=Constant_Marker_Level();
% set(op,'mean_level',0,'sd_level',0);
% markers1.MT.nucleus.AddOperation(op);
% op=Constant_Marker_Level();
% set(op,'mean_level',0,'sd_level',0);
% markers1.MT.cytoplasm.AddOperation(op);
% op=Constant_Marker_Level();
% set(op,'mean_level',0,'sd_level',0);
% markers1.MT.lipid_droplets.AddOperation(op);
op=Constant_Marker_Level();
set(op,'mean_level',0.1,'sd_level',0);
markers1.MT.fiber.AddOperation(op);
op=Perlin_Texture();
set(op,'length_scale',6,'amplitude',0.1,'add_or_multiply','Add');
markers1.MT.fiber.AddOperation(op);
% op=Distance_To_Edge_Marker_Gradient();
% markers1.MT.fiber.AddOperation(op);

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
% op=Constant_Marker_Level();
% set(op,'mean_level',0.7,'sd_level',0.1);
% markers1.Actin.cytoplasm.AddOperation(op);
op=Cell_Density_Dependant_Marker_Level();
set(op,'falloff_type','Exponential','falloff_coefficient',2,'increasing_or_decreasing','Increasing');
markers1.Actin.cytoplasm.AddOperation(op);


% op=Linear_Marker_Gradient();
% set(op,'falloff_type','Linear','falloff_coefficient',0.5);
% markers1.Actin.cytoplasm.AddOperation(op);
% op=Distance_To_Edge_Marker_Gradient();
% set(op,'falloff_type','Gaussian','falloff_coefficient',10,'increasing_or_decreasing','Decreasing');
% markers1.Actin.cytoplasm.AddOperation(op);
% op=Distance_To_Shape_Marker_Gradient();
% set(op,'distance_to',subpop{2}.objects.nucleus,'falloff_type','Exponential','falloff_coefficient',2,'increasing_or_decreasing','Decreasing');
% markers1.Actin.cytoplasm.AddOperation(op);


op=Constant_Marker_Level();
set(op,'mean_level',0,'sd_level',0);
markers1.Actin.nucleus.AddOperation(op);

subpop{2}.compositing=Default_Compositing();
set(subpop{2}.compositing,'container_weight',0);



overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm},0.3);
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.05);



op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.05,'blur_radius',5);
subpop{1}.add_cell_artifact(op);

op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.05,'blur_radius',5);
subpop{2}.add_cell_artifact(op);

% op=Cell_Staining_Artifacts();
% set(op,'fraction_unstained',0.05,'unstained_multiplier',0.05,'fraction_bleached',0.05,'bleaching_multiplier',50);
% subpop{1}.add_cell_artifact(op);
% op=Cell_Staining_Artifacts();
% set(op,'fraction_bleached',0.05,'bleaching_multiplier',50,'fraction_unstained',0.05);
% subpop{2}.add_cell_artifact(op);
% 



simucell_data.image_artifacts=cell(0);
op=Add_Basal_Brightness();
set(op,'basal_level',0.15);
simucell_data.image_artifacts{1}=op;
% op=Linear_Image_Gradient();
% simucell_data.image_artifacts{2}=op;
% set(op,'falloff_type','Exponential','falloff_coefficient',0.1);
op=Radial_Image_Gradient();
simucell_data.image_artifacts{2}=op;
set(op,'falloff_type','Sigmoidal','falloff_radius',50);


simucell_data.population_fractions=[1,0];
simucell_data.number_of_cells=5;
simucell_data.simucell_image_size=[500,500];

simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;
% 
% [obv_del,all_del]=simucell_data.subpopulations{1}.calculate_all_dependancies(...
%     simucell_data.subpopulations{1}.objects.lipid_droplets);
% 
% [obv_del,all_del]=simucell_data.subpopulations{1}.calculate_all_dependancies(...
%     simucell_data.subpopulations{1}.markers.DAPI);
% 
[a,b,c,d,e]=SimuCell_Engine(simucell_data);

end