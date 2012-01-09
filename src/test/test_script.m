function [a,b,c,d,e]=test_script()
subpop=cell(0);


%subpopulation 1
subpop{1}=Subpopulation();
subpop{1}.placement=Random_Placement();
set(subpop{1}.placement,'boundary',100);
objects1=subpop{1}.objects;

objects1.addprop('cytoplasm');
objects1.cytoplasm=Cytoplasm_model;
set(objects1.cytoplasm,'radius',30,'eccentricity',0.2);

objects1.addprop('nucleus');
objects1.nucleus=Centered_nucleus_model;
set(objects1.nucleus,'centered_around',objects1.cytoplasm,'eccentricity',0);

markers1=subpop{1}.markers;

markers1.addprop('DAPI');
markers1.DAPI=Marker(objects1);
op=Constant_marker_level_operation();
set(op,'level',0.5);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_dependant_marker_level_operation();
set(op,'marker',markers1.DAPI.cytoplasm,'region',objects1.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

markers1.addprop('Actin');
markers1.Actin=Marker(objects1);
op=Constant_marker_level_operation();
set(op,'level',0.5);
markers1.Actin.cytoplasm.AddOperation(op);
op=Constant_marker_level_operation();
set(op,'level',0);
markers1.Actin.nucleus.AddOperation(op);

subpop{1}.compositing=default_compositing();
set(subpop{1}.compositing,'container_weight',0);



%subpopulation 2
subpop{2}=Subpopulation();
subpop{2}.placement=Random_Placement();
set(subpop{2}.placement,'boundary',100);
objects1=subpop{2}.objects;

objects1.addprop('cytoplasm');
objects1.cytoplasm=Cytoplasm_model;
set(objects1.cytoplasm,'radius',25,'eccentricity',0.3);

objects1.addprop('nucleus');
objects1.nucleus=Centered_nucleus_model;
set(objects1.nucleus,'centered_around',objects1.cytoplasm,'eccentricity',0,'radius',15);

markers1=subpop{2}.markers;

markers1.addprop('DAPI');
markers1.DAPI=Marker(objects1);
op=Constant_marker_level_operation();
set(op,'level',0.5);
markers1.DAPI.cytoplasm.AddOperation(op);
op=Constant_dependant_marker_level_operation();
set(op,'marker',markers1.DAPI.cytoplasm,'region',objects1.nucleus,'slope',0.5);
markers1.DAPI.nucleus.AddOperation(op);

markers1.addprop('Actin');
markers1.Actin=Marker(objects1);
op=Constant_marker_level_operation();
set(op,'level',0.5);
markers1.Actin.cytoplasm.AddOperation(op);
op=Constant_marker_level_operation();
set(op,'level',0);
markers1.Actin.nucleus.AddOperation(op);

subpop{2}.compositing=default_compositing();
set(subpop{2}.compositing,'container_weight',0);





overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.2);



simucell_data.population_fractions=[0.5,0.5];
simucell_data.number_of_cells=10;
simucell_data.simucell_image_size=[500,500];

simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;

[a,b,c,d,e]=SimuCell_Engine(simucell_data);

end