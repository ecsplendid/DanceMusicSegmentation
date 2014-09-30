function [c] = config_getdefault()

c = segmentation_configuration();

c.memory_efficient = 0;

% 1== github, 2==denis, 3==lindmik
c.dataset = 1;

% Feature Extraction Parameters
c.sampleRate = 4000;
c.secondsPerTile = 5;
c.minTrackLength = 134;
c.maxExpectedTrackWidth = 641;   % (magicisland=380*2 others 350*2)
c.bandwidth = 2; % bandwith for the width of the convolution filter
c.lowPassFilter = 1144; %Hz
c.highPassFilter = 109; %Hz

% figure drawing parameters
c.drawSimMat = 1;
c.compute_confs = 0;
c.draw_confs = 0;

% learning rate for posterior
c.eta = 10;

% shift the solutions by x seconds, seems useless
c.solution_shift = -2;
% gaussian width (>1) higher values pinch the gaussian
c.use_costgaussianwidth = 1;
% suggested: [0.5,1.5], shift the mean of the (gaussian) distribution of
% the cosine matrix, by default its shifted to be mean 0 but the songs are
% not entirely normal, they are represented by a section on the left of the
% distribution, I would guess a value slightly greater than 1 is optimal for
% the symmetry and contig cost matrices. >1 shifts mean higher
c.cosine_normalization = 0.7;

% which cost functions to use and how much weight do they have (>0)

% USE THESE>>>
c.use_costsymmetry        = 0;       c.costsymmetry_incentivebalance = 0.1238;
c.use_costcontigpast      = 0;     c.costcontigpast_incentivebalance = 0.5295;
c.use_costcontigfuture    = 0;   c.costcontigfuture_incentivebalance = 0.5227;
c.use_costsum             = 1;             c.costsum_incentivebalance = 0.5;
c.use_costgaussian        = 1;           c.costgauss_incentivebalance = 0.5;
c.use_costcontigevolution = 0;      c.costevolution_incentivebalance = 0.4;

c.costevolution_normalization = 1;
c.costcontig_normalization = 0.5;
c.costsym_normalization = 1;

c.costsum_normalization = 1;

c.costcontig_pastdiffwindow = 20;
c.costcontig_futurediffwindow = 20;
c.costcontig_evolutiondiffwindow = 3;

c.estimate_tracks = 0;

end

