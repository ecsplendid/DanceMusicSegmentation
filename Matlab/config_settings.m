% config settings
secondsPerTile = 10;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;  %% magicisland=380*2 others 350*2
bandwidth = 5;%Hz
lowPassFilter = 1200;%Hz
highPassFilter = 200;%Hz
gaussian_filterdegree = 2;

% cost matrix transformation
cosine_transformexponent = 1;

% 1, favor short tracks, 2 long tracks, 3 add gauss, 4 multiply gauss
costmatrix_normalizationtype = 0; 

costmatrix_parameter = 0.5;
costmatrix_regularization = 1;
eta = 10;
drawsimmat = 1;
draw_confs = 0;
solution_shift = 0;

contig_symmetrythreshold = 0.3;

use_costsymmetry = 1;
use_costcontig = 1
use_costsum = 1;

% execute_show