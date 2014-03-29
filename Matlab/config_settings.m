% CONFIGURATION SETTINGS

% Feature Extraction Parameters
sampleRate = 4000;
secondsPerTile = 5;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;   % (magicisland=380*2 others 350*2)
bandwidth = 5; % bandwith for the width of the convolution filter
lowPassFilter = 1662; %Hz
highPassFilter = 80; %Hz
gaussian_filterdegree = 2; % for the convolution filter on FFT result

% figure drawing parameters
drawsimmat = 0;
compute_confs = 0;
draw_confs = 0;

% save precomputed cosine matrices in memory for speed
% useful for repetition experiments
% note that the conv and dft get faster with decreasing tile size
use_cosinecache = 1;

% learning rate for posterior
eta = 10;

% shift the solutions by x seconds, seems useless
solution_shift = 0;
% gaussian width (>1) higher values pinch the gaussian
use_costgaussianwidth = 1;
% suggested: [0.5,1.5], shift the mean of the (gaussian) distribution of
% the cosine matrix, by default its shifted to be mean 0 but the songs are
% not entirely normal, they are represented by a section on the left of the
% distribution, I would guess a value slightly greater than 1 is optimal for
% the symmetry and contig cost matrices. >1 shifts mean higher
cosine_normalization = 1;
% contig_windowsize in seconds
contig_windowsize = 8;

% which cost functions to use and how much weight do they have (>0)
% what incentive balance do the respective cost functions have [0,1]
use_costsymmetrysum     = 0.3;        costsymmetrysum_incentivebalance = 0.7;
use_costsymmetrydiff    = 0.9;       costsymmetrydiff_incentivebalance = 0.8;
use_costsymmetry        = 0.1;           costsymmetry_incentivebalance = 0.3;
use_costcontigpast      = 0.9;         costcontigpast_incentivebalance = 0.1;
use_costcontigfuture    = 0.9;       costcontigfuture_incentivebalance = 0.5;
use_costsum             = 0.9;                costsum_incentivebalance = 0.5;
use_costgaussian        = 0.5;              costgauss_incentivebalance = 0.8;
use_costcontigevolution = 0.2;          costevolution_incentivebalance = 0.3;


