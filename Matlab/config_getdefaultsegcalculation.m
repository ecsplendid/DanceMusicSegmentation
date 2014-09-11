function [c] = config_getdefaultsegcalculation()

c = segmentation_configuration();

% 1== github, 2==denis, 3==lindmik
c.dataset = 2;

% config_optimdrive this function will get a configuration
% which has been optimized to calculate the best number of 
% segments for a given radio show

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
% 21: secondsPerTile /in {5,6,...,40} 
% 22: contig penalty /in {0.05,...,5}
    
% Feature Extraction Parameters

c.sampleRate = 4000;
c.secondsPerTile = 14;
c.minTrackLength = 152;
c.maxExpectedTrackWidth = 719;   % (magicisland=380*2 others 350*2)
c.bandwidth = 5; % bandwith for the width of the convolution filter
c.lowPassFilter = 1551; %Hz
c.highPassFilter = 453; %Hz


% figure drawing parameters
c.drawSimMat = 1;
c.compute_confs = 0;
c.draw_confs = 0;

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
c.cosine_normalization = 0.519;
% contig_windowsize in tiles
c.contig_windowsize = 3;
c.contig_penalty = 0.5;

% which cost functions to use and how much linear weight do they have (>0)

% /in [0,] ............................|....../in [0,1]
c.use_costsymmetry        = 0.9081;    c.costsymmetry_incentivebalance = 0.0205;
c.use_costcontigpast      = 0.8548;    c.costcontigpast_incentivebalance = 0.3934;
c.use_costcontigfuture    = 1.8511;   c.costcontigfuture_incentivebalance = 0.5315;
c.use_costsum             = 0.6765;    c.costsum_incentivebalance = 0.3289;
c.use_costgaussian        = 0.8427;   c.costgauss_incentivebalance = 0.3335;
c.use_costcontigevolution = 1.0103;    c.costevolution_incentivebalance = 0.1304;

end

