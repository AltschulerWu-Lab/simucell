%% Microenvironment Example
% In this example we will construct synthetic images of cells which
% demonstrate a 'micro-environmental' effect. More specifically, cells
% placed close to each other in the image will be similar, mimicing the
% effect that might be produced by a non-uniform distribution of some
% chemical over a microscopy plate. Such spatial correlation of phenotypes
% is also seen in tissue. with this in mind, we will construct a tightly
% packed arrangment of cells.
% The cells are 'stained' for 3 markers
% 1) 'DAPI' - only present in the nucleus
% 2) 'menv' - a marker whose level is dependant on microenvironment in the
% sense described above
% 3) 'GFP' - whose level in a cell is inversely correlated with the level
% of menv

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

% Define Subpopulation 1
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
% Here we choose to have cells placed close to existing cells, and so choose the
% 'Nearby_Placement' model
subpop{1}.placement=Nearby_Placement();
% The placement models follow the typical model specification (see SimuCell_Model, Parameter),
% and the user settable parameters can be found in the plugin file. These
% parameters follow the standard set framework. 
% For this model, probability of a pixel being picked is dependent on its
% distance to the nearest existing cell. The functional form of this
% dependence is the probability density function of a poisson distribution
% with mean specified by the 'distance_to_existing' below
set(subpop{1}.placement,'distance_to_existing',15); % (measured in pixels)
set(subpop{1}.placement,'boundary',100); % the boundary is the number of pixels around the edge of the image where no cells are placed
set(subpop{1}.placement,'clustering_probability',0.8); % probability that the cell is part of the cluster, non-clustered cells are placed randomly

%% Set the Object Shape
% Object 1
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
% We choose to use 'Fluid_Shape' which creates 
% elliptically shaped cells normally, but if a cell overlaps with an
% existing cell, it morphs its shape like a fluid around the other cell.
% This produces a tissue like effect.
subpop{1}.objects.cytoplasm.model=Fluid_Shape;
set(subpop{1}.objects.cytoplasm.model,'radius',40);%cell radius in pixels
set(subpop{1}.objects.cytoplasm.model,'eccentricity',0.7);% Gives a fairly elliptical shape
set(subpop{1}.objects.cytoplasm.model,'randomness',0.3);

% Add a nucleus object
add_object(subpop{1},'nucleus');
% We choose a nucleus model that creates an elliptical shaped nucleus at
% the center of some other object (in our case the cytoplasm)
subpop{1}.objects.nucleus.model=Centered_Nucleus_Model;
set(subpop{1}.objects.nucleus.model,'radius',15);%nuclear radius in pixels
set(subpop{1}.objects.nucleus.model,'eccentricity',0.7);% nuclei are typically elliptical
set(subpop{1}.objects.nucleus.model,'centered_around',subpop{1}.objects.cytoplasm); % the nucleus is dran at the center of the cytoplasm
set(subpop{1}.objects.nucleus.model,'randomness',0.2);% make the nuclear shape a little noisy
% Note:
% 1) In the centered around, we need to point to another object. We refer
% to the object itself (subpop{1}.objects.cytoplasm) NOT its model
% (subpop{1}.objects.cytoplasm.model)
% 2) The onus for selecting appropriate models is on the script writer. In
% particular the different object models need to be connected in some way
% (otherwise, the cytoplasm and nucleus of the same cell will be in
% completely different locations). Thus you need to be careful to choose
% one independant model (here the Cytoplasm_Model) that anchors the
% position of the cell, while all other models need to be connected to this
% object (either directy or indirectly).
%% Define Markers
%Setup Markers
% As described in the tutorial, users next add, name  anc choose colors
% for the markers on asubpopulation basis. 
% This is done using the add_marker function. (In
% contrast to the GUI you will have to do this for every subpopulation,
% since we assume different subpopulations can be stained with different
% markers)
% Marker 1
add_marker(subpop{1},'menv', Colors.Red); % This will be the microenvironment dependant marker
% This wil create the object subpop{1}.markers.menv
% As described in the tutorial, marker distribution is specified on an object by object basis.
% In our case this involves defining subvariables subpop{1}.markers.menv.nucleus and
% subpop{1}.markers.menv.cytoplasm which are automatically created by the
% defintion of the marker
% Marker 2
add_marker(subpop{1},'GFP', Colors.Green); % This marker avoids the menv marker
% Marker 3
add_marker(subpop{1},'DAPI', Colors.Blue); % This marker is confined to the nucleus

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
% contained inside the cytoplasm --see compositing -- they need not be
% completely dark)

%%%%%% Microenvironment dependant marker
% The level of this marker is determined by its 'microenvironment'. In other
% words cells near each other in the image will have similar levels of ths
% marker. Additionally the level of this marker is higher at the edges of
% the cells and falls towards the nucleus.
op=Microenvironmental_Marker_Level();
% This plugin first generates a semi-random (with some spatial correlations) 
% 'micro-environment' intensity over the image. Then, the level of the the marker is
% proportional to the intensity of the micro-environment at the location of
% the cell
set(op,'length_scale',3); % The length scale over which spatial correlation exists for the microenvironment. (2 means variations at the length of image, 6 is high frequency variation)
set(op,'frequency_falloff',0.8); % Each higher frequency component amplitude is smaller by this scaling factor
set(op,'noise_type','Turbulent'); % The type of variation in micro-environment. Turbulent causes sharper transitions
subpop{1}.markers.menv.cytoplasm.AddOperation(op); % Once the operation is defined, we add it to the queue

% Have the intensity fall off with the distance to the edge
op=Distance_To_Edge_Marker_Gradient();
set(op,'falloff_type','Exponential');%the intensity fall off functional form
set(op,'falloff_radius',10);%pixels over which intensity falls off by 1/e 
set(op,'increasing_or_decreasing','Decreasing');  %Intensity decreases with distance to the edge
subpop{1}.markers.menv.cytoplasm.AddOperation(op);

%Perlin Texture (scale the intensity from the last step by a noisy texture,
%to make it look more realistic)
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply'); % Scale the intensity by noise (multiply) or add noise to the existing intensity
set(op,'amplitude',0.2);% the amplitude of the noise (0 is not noise, and you probably don't want to go much beyond 1, since intensities are in the [0-1] range)
set(op,'length_scale',5); % This descibes the length scale over which intensity varies. 2 is low wave-length (coarse variation) and 6 is very fine high frequency (fine variation)
set(op,'frequency_falloff',0.8); % Each higher frequency component amplitude is smaller by this scaling factor
set(op,'noise_type','Turbulent');% The type of noise. Turbulent causes sharper transitions
subpop{1}.markers.menv.cytoplasm.AddOperation(op);



%%%%%% GFP
% The level of this marker in a cell is inversely correlated with the
% presence of the Red 'menv' marker. This is achieved using the
% 'Constant_Dependant_Marker_Level' plugin.
% It sets the marker level in to a constant, with the value of this
% constant being varying with the mean level of another marker.
op=Constant_Dependant_Marker_Level();
% If x_(m,r) is the mean level in of marker m in region r, then 
% this plugin sets the intensity of chosen marker in chosen region to be:
% slope*x_(m,r) + intercept
set(op,'slope',-2.5); % slope in the equation above, negative sign means inverse relation
set(op,'intercept',0.9); % intercept in equation above. This is the level the marker will have if the other marker x_(m,r) is zero
set(op,'marker',subpop{1}.markers.menv.cytoplasm);  % The other marker i.e. m on which this marker depends
set(op,'region',subpop{1}.objects.cytoplasm); % The region on which m is calculated i.e. r
set(op,'func','Mean'); 
% The last three lines specify that the mean level of the menv marker
% measured on the cytoplasmic region will be used to determine the level of
% GFP.
subpop{1}.markers.GFP.cytoplasm.AddOperation(op);
% Throw in some noise
%Perlin Texture
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.1);
set(op,'length_scale',5);
set(op,'frequency_falloff',0.7);
set(op,'noise_type','Turbulent');
subpop{1}.markers.GFP.cytoplasm.AddOperation(op);


%%%%%% DAPI
% DAPI is only present in the nucleus. It shows a slight variation from
% cell to cell and some non-uniform texture
op=Constant_Marker_Level();
% Set a constant marker level (uniform across entire object, but varying from cell to cell)
set(op,'mean_level',0.5); % The marker level for a cell is sampled from a normal distribution with this mean
set(op,'sd_level',0.2); % and this standard deviation
subpop{1}.markers.DAPI.nucleus.AddOperation(op);
%Throw in some noisy texture
op=Perlin_Texture();
set(op,'add_or_multiply','Multiply');
set(op,'amplitude',0.3);
set(op,'length_scale',4);
set(op,'frequency_falloff',0.7);
set(op,'noise_type','Standard 1/f');
subpop{1}.markers.DAPI.nucleus.AddOperation(op);


%% Set the Composite Type
subpop{1}.compositing=Default_Compositing();
% Compositing governs the rendering of markers when multiple objects, with
% some expression of the same marker, overlap. For example, suppose a
% marker is present in the nucleus and the cytoplasm. The nucleus is
% contained in the cytoplasm, thus the marker level in the nucleus is a composite
% of its expression from the the nucleus and the cytoplasm. 
% Presently we support just one compositing model, called default compositing. This
% model determines, at run-time, which objects contain which others
% (cytoplasm contains nucleus). The user can then specify the weight given
% to the container (the contained object gets 1-container_weight)
set(subpop{1}.compositing,'container_weight',0);
% In this example the cytoplasm will get 0 weight and nucleus full weight
% nuclear region. Note in the cytoplasmic region where there is no overlap,
% only the model of the marker in the cytoplasm comes into play, and no
% compositing is required.

%% Set the Cell Artifacts
% Add rendering artifacts at a cell by cell level
% Cell artifacts are added using the add_cell_artifact function. Like
% markers, they are defined by a series of operations. Thee operations are
% plugins places in the 'plugins/cell_artifacts/' directory.
%Set the Cell Artifacts
%op=Out_Of_Focus_Cells(); % Makes a specified fracton of cells blurred, to mimic an out of focal plane effect
%set(op,'fraction_blurred',0.1); % 10% cells blurred
%set(op,'blur_radius',4); % blur radius in pixels. 1 is pretty small, 4 produces a clear out of focus effect
%subpop{1}.add_cell_artifact(op);


%% Set Overlap
% We can also specify if cells are allowed to overlap, and to what
% extent. This spans subpopulations, and is stored in the overlap parameter
% of the simucell_data structure.
% This is done by specifying a series of rules for maximum allowed overlap:
% Each rule consists of two parts
% 1) A list (stored as a cell) of objects on which the overlap is measured
% 2) The maximum allowed overlap between these objects, measured as a
% fraction of their areas

overlap=Overlap_Specification;
overlap.AddOverlap({subpop{1}.objects.cytoplasm},0);
simucell_data.overlap=overlap;
% Here we specified that overlap be measured on the cytoplasms of the cells,
% and the 0 means that no overlap is allowed.

% Note:
% 1) Overlaps across subpopulations can be specified. See the polarized
% cell example for a demonstration
% 2) Multiple rules can be added in this way
%   To additionally prevent any nuclear overlap one might add
%   overlap.AddOverlap({subpop{1}.objects.nucleus},0);

%% Set Image Artifact
% simucell_data.image_artifacts=cell(0);
% simucell_data.image_artifacts=cell(0);
% op=Add_Basal_Brightness();
% set(op,'basal_level',0.2);
% simucell_data.image_artifacts{1}=op;
% op=Radial_Image_Gradient();
% set(op,'falloff_type','Gaussian');
% set(op,'falloff_radius',500);
% set(op,'max_multiplier',1.5);
% set(op,'min_multiplier',0.5);
% simucell_data.image_artifacts{2}=op;


%% Set Image Parameters


%Set Number of cell per image
simucell_data.number_of_cells=100;
% Note: If SimuCell cannot fit in any more cells (and still meet the
% overlap conditions) it will generate an image with the maximum number of
% cells it fits in


%Set Image Size (in pixels)
simucell_data.simucell_image_size=[1000,1000];


% You can specify the fractions of cells in the image from the different
% subpopulations (however in this case there is only one subpopulation)
simucell_data.population_fractions=[1];

% assign the subpopulations to the data structure
simucell_data.subpopulations=subpop;

% To invoke the engine
%simucell_result=SimuCell_Engine(simucell_data);image(a);axis off; axis equal;
