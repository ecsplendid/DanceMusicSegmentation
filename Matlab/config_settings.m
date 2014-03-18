%%
% config settings
sampleRate = 4000;

secondsPerTile = 10;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;  %% magicisland=380*2 others 350*2
bandwidth = 5;%Hz
lowPassFilter = 1200;%Hz
highPassFilter = 200;%Hz
gaussian_filterdegree = 2;

% cost matrix transformation
cosine_transformexponent = 1.5;
costmatrix_regularization = 1;

eta = 10;
drawsimmat = 1;
compute_confs=0;
draw_confs = 0;
solution_shift = 0;

costsymmetry_incentivebalance = 0.5;
costcontig_incentivebalance = 0.5;
costsum_incentivebalance = 0.5;

use_costgaussianwidth = 1;

use_costsymmetry = 1;
use_costcontig = 1;
use_costsum = 1;
use_costgaussian = 0;