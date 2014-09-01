function [c] = config_getdefault()

c = segmentation_configuration();

% Feature Extraction Parameters

c.sampleRate = 4000;
c.secondsPerTile = 25;
c.minTrackLength = 180;
c.maxExpectedTrackWidth = 370*2;   % (magicisland=380*2 others 350*2)
c.bandwidth = 5; % bandwith for the width of the convolution filter
c.lowPassFilter = 1662; %Hz
c.highPassFilter = 80; %Hz
c.gaussian_filterdegree = 1; % for the convolution filter on FFT result

% figure drawing parameters
c.drawSimMat = 1;
c.compute_confs = 0;
c.draw_confs = 0;

% save precomputed cosine matrices in memory for speed
% useful for repetition experiments
% note that the conv and dft get faster with decreasing tile size
c.use_cosinecache = 1;

% learning rate for posterior
c.eta = 10;

% shift the solutions by x seconds, seems useless
c.solution_shift = 0;
% gaussian width (>1) higher values pinch the gaussian
c.use_costgaussianwidth = 1;
% suggested: [0.5,1.5], shift the mean of the (gaussian) distribution of
% the cosine matrix, by default its shifted to be mean 0 but the songs are
% not entirely normal, they are represented by a section on the left of the
% distribution, I would guess a value slightly greater than 1 is optimal for
% the symmetry and contig cost matrices. >1 shifts mean higher
c.cosine_normalization = 0.4;
% contig_windowsize in tiles
c.contig_windowsize = 4;

% which cost functions to use and how much weight do they have (>0)

% USE THESE>>>
c.use_costsymmetry        = 0.493;       c.costsymmetry_incentivebalance = 0.711;
c.use_costcontigpast      = 0.971;     c.costcontigpast_incentivebalance = 0.625;
c.use_costcontigfuture    = 0.521;   c.costcontigfuture_incentivebalance = 0.327;
c.use_costsum             = 0.88;             c.costsum_incentivebalance = 0.691;
c.use_costgaussian        = 1.67;           c.costgauss_incentivebalance = 0.482;
c.use_costcontigevolution = 0.823;      c.costevolution_incentivebalance = 0.629;

end

