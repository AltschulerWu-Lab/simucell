%% Polarized Cell Example
% In this example we will construct synthetic images of polarizing cells
% consisting of two subpopulations )cell types): one about to polarize 
% and the other polarized. The cells are "stained" for 3 markers: 
% The red and green marker represent the front and back during polarization, 
% while a third blue marker is dependant on local cell density.

%% simucell_data
% SimuCell requires the user to specify a structure 'simucell_data' to
% specify how images shall be generated. 'simucell_data' contains the
% following fields described in more detail below
%   1) image_size: a vector specifying the size in pixels of the image
%   2) number_of_cells: The number of cells in the image
%   3) subpopulations : A description of the rendering of the individual
%   subpopulations (biological cell types). 'subpopulations' is a MATLAB 
%    (as opposed to biological) cell array, with each element being a class of type
%   'Subpopulation'. The subpopulation class contains specifications of
%   objects (nuclei, cytoplasm and so on), markers (DAPI,...) and other
%   properties that are defined separately on each subpopulation (see
%   below).
%   4) population_fractions: a vector (whose elements must sum up to 1)
%   containing the fractions of cells from the different subpopulations in
%   an image
%   5) overlap: An object of type 'Overlap_Specification' that determines
%   what overlap between cell is allowed
%   6) image_artifacts: a cell array, specifying a sequence of operations
%   that are performed to produce effects simulating imaging artifacts 
%   (e.g. non-uniform illumination) on the whole image 
%   Note: Parameters 1-4 are mandatory, if 5 and/or 6 are not specified,
%   defaults will be used

%% subpopulations
%Create Subpopulation Cell Array
% Subpopulations, i.e. different cells types are the central structure of
% SimuCell. You can have as many subpopulations as you like, each one is
% stores as an element in a cell array.
subpop=cell(0); 
% Note: the contents of 'subpop' will eventually be assigned to 
% 'simucell_data.subpopulations. The use of the temporary variable
% 'subpop' is for ease of reading

%Define Subpopulation 1
% Each subpopulation is an instance of the 'Subpopulation' class defined by
% SimuCell. All cell properties will appear within properties of this
% class.

% The first subpopulation consists of cells which are not yet polarized, and
% are circular in shape. The red and green markers avoid each other (we
% won't model this explicitly), with the red marker concentrated at the
% edge of the cell, and the green marker in the center. The blue marker is
% local cell density dependant: at low densities it is confined to the
% nucleus, but at higher densities it enters the cytoplasm
subpop{1}=Subpopulation();

%Set the Model Placement
% Placement refers to the position of cell in an image.
% Cells in different subpopulations can display different patterns of 
% placement (e.g, one type of cells may be clustered or placed randomly)
% Placement for cells in a subpopulation are specified through the
% placement property in subpopulation, which you need to set the the
% appropriate placement model.
% Models for placments are classes of type SimuCell_Placement_Model, and
% are implemented via plugins (usually placed in the 'plugins/placement/'
% directory).
% Here we choose to have cells placed randomly, and so choose the
% 'Random_Placement' model
subpop{1}.placement=Random_Placement();
% The placement models follow the typical model specification (see SimuCell_Model, Parameter),
% and the user settable parameters can be found in the plugin file. These
% parameters follow the standard set framework. 
set(subpop{1}.placement,'boundary',100);  % the boundary is the number of pixels around the edge of the image where no cells are placed

%Set the Composite Type
% Compositing governs the rendering of markers when multiple objects, with
% some expression of the same marker, overlap. For example, suppose a
% marker is present in the nucleus and the cytoplasm. The nucleus is
% contained in the cytoplasm, thus the marker level in the nucleus is a composite
% of its expression from the the nucleus and the cytoplasm. 
% Presently we support just one compositing model, called default compositing. This
% model determines, at run-time, which objects contain which others
% (cytoplasm contains nucleus). The user can then specify the weight given
% to the container (the contained object gets 1-container_weight)
subpop{1}.compositing=default_compositing();
set(subpop{1}.compositing,'container_weight',0.3);
% In this example the cytoplasm will get 0.3 weight and nucleus 0.7 in the
% nuclear region. Note in the cytoplasmic region where there is no overlap,
% only the model of the marker in the cytoplasm comes into play, and no
% compositing is required.

%% SP1 Shape
%Set the Object Shape
% As described in the tutorial, users are required to add and name the objects on a
% subpopulation basis. This is done using the add_object function. 
add_object(subpop{1},'cytoplasm');
% This will create objects of the specified name inside the objects property of
% the subpopulation object. Thus in this case we have subpop{1}.objects.cytoplasm
% Next we need to choose an appropriate model to render the shape of this
% object. The available shape models are inside tye directory 'plugins/shape/'. For
% organizational purposes, these plugins are placed in sub-directories
% (cytoplasm, nucleus and other). 
% We choose to have the standard Cytoplasm_model which creates an
% elliptical cell shape
subpop{1}.objects.cytoplasm.model=Cytoplasm_model;
set(subpop{1}.objects.cytoplasm.model,'radius',40); %cell radius in pixels
set(subpop{1}.objects.cytoplasm.model,'eccentricity',0.01); % Gives a nearly circular cell
set(subpop{1}.objects.cytoplasm.model,'randomness',0.05); %0 is no noise, and 1 is all noise, so this cell is fairly smooth

% Add a nucleus object
add_object(subpop{1},'nucleus');
% We choose a nucleus model that creates an elliptical shaped nucleus at
% the center of some other object (in our case the cytoplasm)
subpop{1}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{1}.objects.nucleus.model,'radius',15); %nuclear radius in pixels
set(subpop{1}.objects.nucleus.model,'eccentricity',0.6); % nuclei are typically elliptical
set(subpop{1}.objects.nucleus.model,'randomness',0.2); % make the nuclear shape a little noisy
set(subpop{1}.objects.nucleus.model,'centered_around',subpop{1}.objects.cytoplasm); % the nucleus is dran at the center of the cytoplasm
% Note:
% 1) In the centered around, we need to point to another object. We refer
% to the object itself (subpop{1}.objects.cytoplasm) NOT its model
% (subpop{1}.objects.cytoplasm.model)
% 2) The onus for selecting appropriate models is on the script writer. In
% particular the different object models need to be connected in some way
% (otherwise, the cytoplasm and nucleus of the same cell will be in
% completely different locations). Thus you need to be careful to choose
% one independant model (here the Cytoplasm_model) that anchors the
% position of the cell, while all other models need to be connected to this
% object (either directy or indirectly).


%% SP1 Markers
%Setup Markers
% As described in the tutorial, users next add, name  anc choose colors
% for the markers on asubpopulation basis. 
% This is done using the add_marker function. (In
% contrast to the GUI you will have to do this for every subpopulation,
% since we assume different subpopulations can be stained with different
% markers)
%Marker 1
add_marker(subpop{1},'Actin','Green');
% This wil create the object subpop{1}.markers.Actin 
% As described in the tutorial, marker distribution is specified on an object by object basis.
% In our case this involves defining subvariables subpop{1}.markers.Actin.nucleus and
% subpop{1}.markers.Actin.cytoplasm which are automatically created by the
% defintion of the marker

% In contrast to the shape, marker distribution on an object is specified
% in terms of a series of elementary operations. So the standard workflow
% is to define each operation and add it to the queue of operations for the
% specific marker-object pair. The available operations are present as
% plugins in the 'plugins/markers/' directory.

% As described in the tutorial the first operation typically sets the overall level
% of a marker in the object, while the subsequent operations redistribute
% the intensity distribution within the object.

% Note: We do not define the first two markers on the nucleus, this will
% set their level to be zero in the nucleus (but since the nucleus is
% contained inside the cytoplasm --see compositing -- they will not be
% completely dark)

% Set a constant marker level (uniform across entire object, but varying from cell to cell)
op=Constant_marker_level_operation();
set(op,'mean_level',0.7); % The marker level for a cell is sampled from a normal distribution with this mean
set(op,'sd_level',0.1); % and this standard deviation
subpop{1}.markers.Actin.cytoplasm.AddOperation(op); % Once the operation is defined, we add it to the queue

% We want the first marker to essentially cluster near the center of the
% cell, and die out before the edge of the cell. Since the cells in this subpopulation are spherical, this can be
% parametrized in terms of the distance to the nucleus.
%Add Radial Gradient (scaling of intensity at a pixel decreases with distance of that pixel to the nucleus)
op=Distance_to_shape_marker_gradient();
set(op,'falloff_radius',10); % The number of pixels over which intensity falls by 1/e
set(op,'falloff_type','Gaussian'); % the intensity fall off functional form
set(op,'increasing_or_decreasing','Decreasing'); % whether intensity increases or decreases based on the distance
set(op,'distance_to',subpop{1}.objects.nucleus); % distance is measure wrt the nucleus
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
%Perlin Texture (scale the intensity from the last step by a noisy texture,
%to make it look more realistic)
op=Perlin_Texture();
set(op,'amplitude',0.3); % the amplitude of the noise (0 is not noise, and you probably don't want to go much beyond 1, since intensities are in the [0-1] range)
set(op,'length_scale',5); % This descibes the length scale over which intensity varies. 2 is low wave-length (coarse variation) and 6 is very fine high frequency (fine variation)
set(op,'frequency_falloff',0.5); % Each higher frequency component amplitude is smaller by this scaling factor
set(op,'noise_type','Turbulent'); % The type of noise. Turbulent causes sharper transitions
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);
% We further create the impression of turbulence using the turbulent
% texture which semi-randomly moves pixels around locally, as might happen
% in a turbulent fluid,
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',7); % This is the max distance in pixels that a pixel can be moved
set(op,'length_scale',5); % same length scale defiition as Perlin above
set(op,'frequency_falloff',0.8); % same as Perlin above
subpop{1}.markers.Actin.cytoplasm.AddOperation(op);

% We want the second marker to be distribtued at the edge of the cell, so
% we use a plugin that has intensity fall off rapidly with distance to the
% edge
%Marker 2
add_marker(subpop{1},'Myosin','Red');
% Initial intensity set to a constant (over all pixels) for a specific cell, but
% sampled from a random distribution across cells
op=Constant_marker_level_operation();
set(op,'mean_level',0.9);
set(op,'sd_level',0.1);
subpop{1}.markers.Myosin.cytoplasm.AddOperation(op);

%Add Radial Gradient
% Have the intensity fall off rapidly with the distance to the edge
op=Distance_to_edge_marker_gradient();
set(op,'falloff_radius',10); %pixels over which intensity falls off by 1/e 
set(op,'falloff_type','Gaussian'); %the intensity fall off functional form
set(op,'increasing_or_decreasing','Decreasing'); %Intensity decreases with distance to the edge
subpop{1}.markers.Myosin.cytoplasm.AddOperation(op);
% Throw in some turbulence to make it look more realistic
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.7);
subpop{1}.markers.Myosin.cytoplasm.AddOperation(op);


% The third marker is essentially confined to the nucleus when there are no
% other cells nearby, but rushes out into the cytoplasm when local cell
% density becomes high. This is implemented by having the intensity in the
% nucleus depend on the the local cell density and the intensity in the
% cytoplasm be begatively correlated with the intensity in the nucleus
% %Marker 3
 add_marker(subpop{1},'Density_Marker','Blue');


%Cell Density Effect
% Set the marker level in nucleus be decided by the distance to nearest
% other cell. Internally, for each cell,  average distance to nearest other
% cell is calculated, and nuclear intensity varies with this distance
op=Cell_Density_Dependant_Marker_Level();
set(op,'max_level',2); % Max level (theoretically) possible, if cells were on top of each other (increasing this increases brightness across all cells)
set(op,'falloff_radius',200); % The distance (in pixels) that the nearest cell must be on average for intensity to fall off by a factor of 1/e
set(op,'falloff_type','Gaussian'); % Functional form of dependance of intensity on the average distance to nearest cell
set(op,'increasing_or_decreasing','Decreasing'); % Does intensity increase or decrease with local cell density?
subpop{1}.markers.Density_Marker.nucleus.AddOperation(op);
% Throw in some noise
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.7);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
% set(op,'noise_type','Turbulent');
subpop{1}.markers.Density_Marker.nucleus.AddOperation(op);
% Throw in some turbulence
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.7);
subpop{1}.markers.Density_Marker.nucleus.AddOperation(op);

% Set the marker level in the cytoplasm to a constant, with this constant
% varying inversely with the mean level of the marker in the nucleus
op=Constant_dependant_marker_level_operation(); % If x_(m,r) is the mean level in of marker m in region r, then 
% this plugin sets the intensity of chosen marker in chosen region to be:
% slope*x_(m,r) + intercept
set(op,'slope',-1.2); % slope in the equation above, negative sign means inverse relation
set(op,'intercept',0.6); % intercept in equation above. This is the level the marker will have if the other marker x_(m,r) is zero
set(op,'marker',subpop{1}.markers.Density_Marker.nucleus); % The other marker i.e. m on which this marker depends
set(op,'region',subpop{1}.objects.nucleus); % The region on which m is calculated i.e. r
subpop{1}.markers.Density_Marker.cytoplasm.AddOperation(op);
% Throw in some noise
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.4);
set(op,'length_scale',3);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{1}.markers.Density_Marker.cytoplasm.AddOperation(op);
%% SP1 Rendering
% Add rendering artifacts at a cell by cell level
% Cell artifacts are added using the add_cell_artifact function. Like
% markers, they are defined by a series of operations. Thee operations are
% plugins places in the 'plugins/cell_artifacts/' directory.
%Set the Cell Artifacts
op=Out_Of_Focus_Cells(); % Makes a specified fracton of cells blurred, to mimic an out of focal plane effect
set(op,'fraction_blurred',1); % All cells blurred
set(op,'blur_radius',2);% blur radius in pixels. 1 is pretty small, chosen to produce a very slight smoothing effect on all cells
subpop{1}.add_cell_artifact(op);
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.1); % For a few cells (10%)
set(op,'blur_radius',4); % we choose to make them more seriously out of focus
subpop{1}.add_cell_artifact(op);

%% Subpopulation 2
% Repeat the same procedure for the seconf subpopulation. 
% This subpopulation consists of polarized cells that are no longer circular.
% The red marker and green marker avoid each other and go to different ends of the cell. As in the
% previous sub-population the blue marker shows a density dependance
% (confined to nucleus at low cell density and entering the cytoplasm at
% higer densities).


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
subpop{2}.objects.cytoplasm.model=Cytoplasm_model;
set(subpop{2}.objects.cytoplasm.model,'radius',60);
set(subpop{2}.objects.cytoplasm.model,'eccentricity',0.6); % Note this subpopulation is far more eccentric than the first
set(subpop{2}.objects.cytoplasm.model,'randomness',0.2);

add_object(subpop{2},'nucleus');
subpop{2}.objects.nucleus.model=Centered_nucleus_model;
set(subpop{2}.objects.nucleus.model,'radius',10);
set(subpop{2}.objects.nucleus.model,'eccentricity',0.6);
set(subpop{2}.objects.nucleus.model,'randomness',0.2);
set(subpop{2}.objects.nucleus.model,'centered_around',subpop{2}.objects.cytoplasm);


%% SP2 Markers
% Like for the first subpopulation we have the Red marker at the edge,
% however we add an angular dependance so that it is confined to one side
% of the cell and appears polarized,
%Marker 1
add_marker(subpop{2},'Myosin','Red');
op=Constant_marker_level_operation();
set(op,'mean_level',0.8);
set(op,'sd_level',0.1);
subpop{2}.markers.Myosin.cytoplasm.AddOperation(op);
%Add Angular gradient 
op=Angular_marker_gradient();
% the angle made by every pixel (measured with respect to a point
% determined by the 'center' parameter) with a randomly chosen direction is
% calculated. The intensity at the pixels falls off with this angle, with
% the functional form specified in 'falloff_type' falling to 1/e at
% 'angular_width'
set(op,'center','Furthest From Edge');
set(op,'angular_width',30);
set(op,'falloff_type','Exponential');
set(op,'min_multiplier',0);
subpop{2}.markers.Myosin.cytoplasm.AddOperation(op);
%Add Radial Gradient
op=Distance_to_edge_marker_gradient();
set(op,'falloff_radius',15);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
subpop{2}.markers.Myosin.cytoplasm.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.5);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{2}.markers.Myosin.cytoplasm.AddOperation(op);
% Turbulent Texture
op=Turbulent_Texture();
set(op,'max_displacement',5);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.8);
subpop{2}.markers.Myosin.cytoplasm.AddOperation(op);



%Marker 2
add_marker(subpop{2},'Actin','Green');
% In this case we have the green marker depend on the the red one, and
% avoid it. This is done at a pixel level. If I is the intensity of the red
% marker at a pixel then the intensity of the green marker is:
% slope*I+intercept (where slope and intercept are specified below). A
% negative value of the slope implies supression. 
op=Locally_dependant_marker_level_operation();
set(op,'slope',-100); % The red marker strongly supresses the green one. 
set(op,'intercept',0.8);
set(op,'marker',subpop{2}.markers.Myosin.cytoplasm);
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
add_marker(subpop{2},'Density_Marker','Blue');
op=Cell_Density_Dependant_Marker_Level();
set(op,'max_level',2);
set(op,'falloff_radius',200);
set(op,'falloff_type','Gaussian');
set(op,'increasing_or_decreasing','Decreasing');
subpop{2}.markers.Density_Marker.nucleus.AddOperation(op);
%Perlin Texture
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.7);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.8);
% set(op,'noise_type','Turbulent');
subpop{2}.markers.Density_Marker.nucleus.AddOperation(op);


op=Constant_dependant_marker_level_operation();
set(op,'slope',-1.2);
set(op,'intercept',0.6);
set(op,'marker',subpop{2}.markers.Density_Marker.nucleus);
set(op,'region',subpop{2}.objects.nucleus);
subpop{2}.markers.Density_Marker.cytoplasm.AddOperation(op);
%Perlin Texture
op=Perlin_Texture();
set(op,'amplitude',0.4);
set(op,'length_scale',3);
set(op,'frequency_falloff',0.8);
set(op,'noise_type','Turbulent');
subpop{2}.markers.Density_Marker.cytoplasm.AddOperation(op);

%% SP2 Rendering
%Set the Cell Artifacts
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',1);
set(op,'blur_radius',2);
subpop{2}.add_cell_artifact(op);
op=Out_Of_Focus_Cells();
set(op,'fraction_blurred',0.1);
set(op,'blur_radius',4);
%subpop{2}.add_cell_artifact(op);

%% Common to all subpops

% We can also specify if cells are allowed to overlap, and to what
% extent. This spans subpopulations, and is stored in the overlap parameter
% of the simucell_data structure.
% This is done by specifying a series of rules for maximum allowed overlap:
% Each rule consists of two parts
% 1) A list (stored as a cell) of objects on which the overlap is measured
% 2) The maximum allowed overlap between these objects, measured as a
% fraction of their areas

overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm,subpop{2}.objects.cytoplasm},0.05);
simucell_data.overlap=overlap;
% Here we specified that overlap be measured on the cytoplasms of the two
% populations, and the 0.05 means that 5% overlap is allowed.

% Note:
% 1) Overlap with shapes of the same type is also assumed to be specified from the rules. So in the
%   above case the overlap in the cytoplasm cannot exceed 5% for
%   a) two cells of subpopulation 1
%   b) two cels of subpopulation 2
%   c) one cell of subpopulation 1 and one cell of subpopulation 2
% 2) Multiple rules can be added in this way
%   To additionally prevent any nuclear overlap one might add
%   overlap.AddOverlap({subpop{1}.objects.nucleus,subpop{2}.objects.nucleus},0);


% Simucell also supports adding of imaging effects at the whole cell level
% (examples include non-uniform illumination)
% Like the cell artifacts, this is stored as a sequence of operations. In
% this case however, we do not provide an add operation function, instead
% the user must directly add operations as elements to the image_artifacts
% property (which is a cell) of the simucell_data structure
% 
% %simucell_data.image_artifacts=cell(0);
% %op=Add_Basal_Brightness();
% %set(op,'basal_level',0.1);
% %simucell_data.image_artifacts{1}=op;
% %op=Radial_Image_Gradient();
% %simucell_data.image_artifacts{2}=op;
% %set(op,'falloff_type','Sigmoidal','falloff_radius',200);

% You can specify the fractions of cells in the image from the different subpopulations
simucell_data.population_fractions=[0.5 0.5]; % These must sum up to 1
% Note: subpopulation is chosen stochastically, and the above statement
% means each cell added has 50% probability of belonging to each
% subpopulation. Thus individual images will not have exactly this fraction
% of cells from the subpopulations

% The total number of cells in the image
simucell_data.number_of_cells=7;
% Note: If SimuCell cannot fit in any more cells (and still meet the
% overlap conditions) it will generate an image with the maximum number of
% cells it fits in

% The size of the image generated by SimuCell
simucell_data.simucell_image_size=[700,700];

% assign the subpopulations to the data structure
simucell_data.subpopulations=subpop;

[a,b,c,d,e]=SimuCell_Engine(simucell_data);image(a);axis off; axis equal;

