function [a,b,c]=test_script()
subpop=cell(0);



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
set(op,'level',1);
markers1.DAPI.nucleus=markers1.DAPI.nucleus.AddOperation(op);

overlap=Overlap_Specification;
overlap.AddOverlap({objects1.cytoplasm},0);

simucell_data.population_fractions=[1];
simucell_data.number_of_cells=15;
simucell_data.simucell_image_size=[500,500];

simucell_data.subpopulations=subpop;
simucell_data.overlap=overlap;

[a,b,c]=SimuCell_Engine(simucell_data);

end