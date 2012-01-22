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

add_marker(subpop{1},'DAPI');
op=Constant_marker_level_operation();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_dependant_marker_level_operation();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{1}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{1},'Actin');
op=Constant_marker_level_operation();
set(op,'mean_level',0.7,'sd_level',0.1);
markers1.Actin.cytoplasm.AddOperation(op);
op=Constant_marker_level_operation();
set(op,'mean_level',0,'sd_level',0);
markers1.Actin.nucleus.AddOperation(op);

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

add_marker(subpop{2},'DAPI');
op=Constant_marker_level_operation();
set(op,'mean_level',0.5,'sd_level',0.1);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_dependant_marker_level_operation();
set(op,'marker',markers1.DAPI.cytoplasm,'region',subpop{2}.objects.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

add_marker(subpop{2},'Actin');
op=Constant_marker_level_operation();
set(op,'mean_level',0.7,'sd_level',0.1);
markers1.Actin.cytoplasm.AddOperation(op);
op=Constant_marker_level_operation();
set(op,'mean_level',0,'sd_level',0);
markers1.Actin.nucleus.AddOperation(op);

subpop{2}.compositing=default_compositing();
set(subpop{2}.compositing,'container_weight',0);



overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.05);


op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.2,'blur_radius',10);
subpop{1}.add_cell_artifact(op);
subpop{2}.add_cell_artifact(op);


simucell_data.population_fractions=[0.5,0.5];
simucell_data.number_of_cells=30;
simucell_data.simucell_image_size=[800,800];

simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;

[a,b,c,d,e]=SimuCell_Engine(simucell_data);

end