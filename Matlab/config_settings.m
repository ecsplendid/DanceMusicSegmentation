%%
% config settings
sampleRate = 4000;

secondsPerTile = 20;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;  %% magicisland=380*2 others 350*2
bandwidth = 5;%Hz
lowPassFilter = 1200;%Hz
highPassFilter = 200;%Hz
gaussian_filterdegree = 2;

% cost matrix transformation
cosine_transformexponent = 1;
costmatrix_regularization = 1;
eta = 10;
drawsimmat = 1;
compute_confs=0;
draw_confs = 1;
solution_shift = 0;

costcontig_incentivebalance = 0.5;
costsum_incentivebalance = 0.5;
costsymmetry_incentivebalance = 0.5;
costgauss_incentivebalance = 0.5;

use_costgaussianwidth = 2;

contig_symmetrythreshold = 0.4;

use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 0.5;