% CONFIGURATION SETTINGS

% Feature Extraction Parameters
sampleRate = 4000;
secondsPerTile = 15;
minTrackLength = 180;
maxExpectedTrackWidth = 370*2;   % (magicisland=380*2 others 350*2)
bandwidth = 5; % bandwith for the width of the convolution filter
lowPassFilter = 1500; %Hz
highPassFilter = 80; %Hz
gaussian_filterdegree = 2; % for the convolution filter on FFT result

% figure drawing parameters
drawsimmat = 1;
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
cosine_normalization = 1.2;
contig_windowsize = 4;

% which cost functions to use and how much weight do they have (>0)
% what incentive balance do the respective cost functions have [0,1]
use_costsymmetrysum     = 0;        costsymmetrysum_incentivebalance = 0.5;
use_costsymmetrydiff    = 0;       costsymmetrydiff_incentivebalance = 0.5;
use_costsymmetry        = 0;           costsymmetry_incentivebalance = 0.5;
use_costcontigpast      = 0;         costcontigpast_incentivebalance = 0.5;
use_costcontigfuture    = 0;       costcontigfuture_incentivebalance = 0.5;
use_costsum             = 1;                costsum_incentivebalance = 0.5;
use_costgaussian        = 0;              costgauss_incentivebalance = 0.5;
use_costcontigevolution = 0;          costevolution_incentivebalance = 0.5;


