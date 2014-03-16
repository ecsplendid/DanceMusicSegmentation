% config settings
secondsPerTile = 20;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;  %% magicisland=380*2 others 350*2
bandwidth = 5;%Hz
lowPassFilter = 1200;%Hz
highPassFilter = 200;%Hz
gaussian_filterdegree = 2;

% cost matrix transformation
cosine_transformexponent = 1;

% 1, favor short tracks, 2 long tracks, 3 add gauss, 4 multiply gauss
% NOW DEPRECIATED
costmatrix_normalizationtype = 0; 

costmatrix_parameter = 0.1;
costmatrix_regularization = 1;
eta = 10;
drawsimmat = 1;
draw_confs = 0;
solution_shift = 0;

contig_regularization = 2;
symmetry_regularization = 2;
sum_regularization = 0.8;

use_costgaussianwidth = 1;

contig_symmetrythreshold = 0.35;

use_costsymmetry = 1;
use_costcontig = 1;
use_costsum = 1;
use_costgaussian = 0.5;


% execute_show