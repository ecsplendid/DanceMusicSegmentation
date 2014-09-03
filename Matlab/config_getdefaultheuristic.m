function [c] = config_getdefaultheuristic()

c = segmentation_configuration();

% 1== github, 2==denis, 3==lindmik
c.dataset = 1;

% these are the best heuristic parameters

% try driving this with 
% config_optimdrive(config_optimdrivebounds_randomstart())

% 1: sumIB /in [0,1]    
% 2: sum_contribution /in [0,2]
% 3: symIB /in [0,1]
% 4: sym contr /in [0,1]
% 5: evolution IB /in [0,1]
% 6: evolution contr /in [0,2]
% 7: contigpast IB /in [0,1]
% 8: contigpast contr /in [0,2]
% 9: contigfut IB /in [0,1]
% 10: contigfut contr /in [0,2]
% 11: gauss IB /in [0,1]
% 12: gauss cont /in [0,2]
% 13: cosine norm /in [0.4,1.4]
% 14: contig window /in {1,2,...,5}
% 15: solution_shift /in {-3,-2,-1,0,1,2,3}
% 16: minTrackLength /in {120,121,...,220}
% 17: maxExpectedTrackWidth /in {6*60,...,15*60}
% 18: bandwidth /in {1,2,...,15}
% 19: lowPassFilter /in {800,...,1950}
% 20: highPassFilter /in {50,...,500}
% 21: gaussian_filterdegree /in {1,2,3,4,5,6}
% 22: secondsPerTile /in {5,6,...,40} 
    
% Feature Extraction Parameters

c.sampleRate = 4000;
c.secondsPerTile = 5;
c.minTrackLength = 172;
c.maxExpectedTrackWidth = 655;   % (magicisland=380*2 others 350*2)
c.bandwidth = 4; % bandwith for the width of the convolution filter
c.lowPassFilter = 1010; %Hz
c.highPassFilter = 64; %Hz
c.gaussian_filterdegree = 2; % for the convolution filter on FFT result

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
c.solution_shift = -3;
% gaussian width (>1) higher values pinch the gaussian
c.use_costgaussianwidth = 1;
% suggested: [0.5,1.5], shift the mean of the (gaussian) distribution of
% the cosine matrix, by default its shifted to be mean 0 but the songs are
% not entirely normal, they are represented by a section on the left of the
% distribution, I would guess a value slightly greater than 1 is optimal for
% the symmetry and contig cost matrices. >1 shifts mean higher
c.cosine_normalization = 0.792;
% contig_windowsize in tiles
c.contig_windowsize = 2;

% which cost functions to use and how much linear weight do they have (>0)

% /in [0,] ............................|....../in [0,1]
c.use_costsymmetry        = 0.685;    c.costsymmetry_incentivebalance = 0.458;
c.use_costcontigpast      = 0.784;    c.costcontigpast_incentivebalance = 0.399;
c.use_costcontigfuture    = 0.835;   c.costcontigfuture_incentivebalance = 0.85;
c.use_costsum             = 1.45;    c.costsum_incentivebalance = 0.139;
c.use_costgaussian        = 1.01;   c.costgauss_incentivebalance = 0.676;
c.use_costcontigevolution = 1.91;    c.costevolution_incentivebalance = 0.518;

end

