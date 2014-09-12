function [c] = config_optimdrive(ibev, dataset)

    c = segmentation_configuration();

	c.dataset = 1;
    
    if( nargin > 1 )
        c.dataset = dataset;
        
        if c.dataset > 1 % cant store all the cosines/cost matrices
            c.memory_efficient = 1;
        end
    end

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
    % 14: solution_shift /in {-3,-2,-1,0,1,2,3}
    % 15: minTrackLength /in {120,121,...,220}
    % 16: maxExpectedTrackWidth /in {6*60,...,15*60}
    % 17: bandwidth /in {1,2,...,15}
    % 18: lowPassFilter /in {800,...,1950}
    % 19: highPassFilter /in {50,...,500}
    % 20: secondsPerTile /in {5,6,...,40} 
    % 21: contig penalty /in {0.05,...,5}
    
    % see config_optimdrivebounds for bounds and random start driver
    
    % random start: [rand, rand*2, rand, rand*2, rand, rand*2, rand, rand*2, rand, rand*2, rand, rand*2, (rand)+0.5, round(rand*6)+1]
    % ubounds = [1,2,1,2,1,2,1,2,1,2,1,2,1.5,5]
    % lbounds = [0,0,0,0,0,0,0,0,0,0,0,0,0.4,1]



% Feature Extraction Parameters

c.sampleRate = 4000;
c.secondsPerTile = round(ibev(20));
c.minTrackLength = round(ibev(15));
c.maxExpectedTrackWidth = round(ibev(16));   % (magicisland=380*2 others 350*2)
c.bandwidth = round(ibev(17)); % bandwith for the width of the convolution filter
c.lowPassFilter = round(ibev(18)); %Hz
c.highPassFilter = round(ibev(19)); %Hz

% figure drawing parameters
c.drawSimMat = 1;
c.compute_confs = 0;
c.draw_confs = 0;

% learning rate for posterior
c.eta = 10;

% shift the solutions by x seconds, seems useless
c.solution_shift = round(ibev(14));
% gaussian width (>1) higher values pinch the gaussian
c.use_costgaussianwidth = 1;
% suggested: [0.5,1.5], shift the mean of the (gaussian) distribution of
% the cosine matrix, by default its shifted to be mean 0 but the songs are
% not entirely normal, they are represented by a section on the left of the
% distribution, I would guess a value slightly greater than 1 is optimal for
% the symmetry and contig cost matrices. >1 shifts mean higher
c.cosine_normalization = ibev(13);

c.contig_penalty = ibev(21);

% which cost functions to use and how much linear weight do they have (>0)

% /in [0,] ............................|....../in [0,1]
c.use_costsymmetry        = ibev(4);    c.costsymmetry_incentivebalance = ibev(3);
c.use_costcontigpast      = ibev(8);    c.costcontigpast_incentivebalance = ibev(7);
c.use_costcontigfuture    = ibev(10);   c.costcontigfuture_incentivebalance = ibev(9);
c.use_costsum             = ibev(2);    c.costsum_incentivebalance = ibev(1);
c.use_costgaussian        = ibev(12);   c.costgauss_incentivebalance = ibev(11);
c.use_costcontigevolution = ibev(6);    c.costevolution_incentivebalance = ibev(5);


c.costevolution_normalization = ibev(22);
c.costsum_normalization= ibev(23);
c.costcontig_normalization= ibev(24);
c.costsym_normalization= ibev(25);


end