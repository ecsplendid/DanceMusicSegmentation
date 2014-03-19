% CONFIGURATION SETTINGS

% Feature Extraction Parameters
sampleRate = 4000;
secondsPerTile = 20;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;   % (magicisland=380*2 others 350*2)
bandwidth = 5; % bandwith for the width of the convolution filter
lowPassFilter = 1200; %Hz
highPassFilter = 200; %Hz
gaussian_filterdegree = 2; % for the convulution filter on FFT result

% figure drawing parameters
drawsimmat = 1;
compute_confs=0;
draw_confs = 0;

% learning rate for posterior
eta = 10;

% shift the solutions by x seconds, seems useless
solution_shift = 0;
% gaussian width (>1) higher values pinch the gaussian
use_costgaussianwidth = 1;

% which cost functions to use and how much weight do they have (>0)
use_costsymmetry = 1;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 1;

% what incentive balance do the respective cost functions have [0,1]
costsymmetry_incentivebalance = 0.5;
costcontig_incentivebalance = 0.2;
costsum_incentivebalance = 0.5;
costgauss_incentivebalance = 0.5;