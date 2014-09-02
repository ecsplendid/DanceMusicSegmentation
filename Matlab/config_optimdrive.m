function [c] = config_optimdrive(ibev)

    % config_optimdrive this function will get a configuration
    % driven by a random input vector from fmincon as part of the 
    % process of finding the best config
    
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
    
    % see config_optimdrivebounds for bounds and random start driver
    
    % random start: [rand, rand*2, rand, rand*2, rand, rand*2, rand, rand*2, rand, rand*2, rand, rand*2, (rand)+0.5, round(rand*6)+1]
    % ubounds = [1,2,1,2,1,2,1,2,1,2,1,2,1.5,5]
    % lbounds = [0,0,0,0,0,0,0,0,0,0,0,0,0.4,1]

    c = segmentation_configuration();

% Feature Extraction Parameters

c.sampleRate = 4000;
c.secondsPerTile = round(ibev(22));
c.minTrackLength = round(ibev(16));
c.maxExpectedTrackWidth = round(ibev(17));   % (magicisland=380*2 others 350*2)
c.bandwidth = round(ibev(18)); % bandwith for the width of the convolution filter
c.lowPassFilter = round(ibev(19)); %Hz
c.highPassFilter = round(ibev(20)); %Hz
c.gaussian_filterdegree = round(ibev(21)); % for the convolution filter on FFT result

% figure drawing parameters
c.drawSimMat = 0;
c.compute_confs = 0;
c.draw_confs = 0;

% save precomputed cosine matrices in memory for speed
% useful for repetition experiments
% note that the conv and dft get faster with decreasing tile size
c.use_cosinecache = 1;

% learning rate for posterior
c.eta = 10;

% shift the solutions by x seconds, seems useless
c.solution_shift = round(ibev(15));
% gaussian width (>1) higher values pinch the gaussian
c.use_costgaussianwidth = 1;
% suggested: [0.5,1.5], shift the mean of the (gaussian) distribution of
% the cosine matrix, by default its shifted to be mean 0 but the songs are
% not entirely normal, they are represented by a section on the left of the
% distribution, I would guess a value slightly greater than 1 is optimal for
% the symmetry and contig cost matrices. >1 shifts mean higher
c.cosine_normalization = ibev(13);
% contig_windowsize in tiles
c.contig_windowsize = round(ibev(14));

% which cost functions to use and how much linear weight do they have (>0)

% /in [0,] ............................|....../in [0,1]
c.use_costsymmetry        = ibev(4);    c.costsymmetry_incentivebalance = ibev(3);
c.use_costcontigpast      = ibev(8);    c.costcontigpast_incentivebalance = ibev(7);
c.use_costcontigfuture    = ibev(10);   c.costcontigfuture_incentivebalance = ibev(9);
c.use_costsum             = ibev(2);    c.costsum_incentivebalance = ibev(1);
c.use_costgaussian        = ibev(12);   c.costgauss_incentivebalance = ibev(11);
c.use_costcontigevolution = ibev(6);    c.costevolution_incentivebalance = ibev(5);

end