%%
% config settings
sampleRate = 4000;
secondsPerTile = 20;
minTrackLength = 180;

% magicisland=380*2 others 350*2
maxExpectedTrackWidth = 370*2;  
bandwidth = 5;%Hz
lowPassFilter = 1200;%Hz
highPassFilter = 200;%Hz
gaussian_filterdegree = 2;

eta = 10;
drawsimmat = 1;
compute_confs=0;
draw_confs = 0;
solution_shift = 0;
use_costgaussianwidth = 1;


costsymmetry_incentivebalance = 0.7;
costcontig_incentivebalance = 0.7;
costsum_incentivebalance = 0.5;
costgauss_incentivebalance = 0.1;


use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 1;

