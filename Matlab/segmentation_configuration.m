classdef segmentation_configuration
    % all the config properties can be encapsulated in this class so that
    % they can be passed around to other functions easily without having
    % to resort to global variables
    
    properties
        memory_efficient = 1; % wipe CosineMatrix and CostMatrix after run
        dataset = 1 % 1==github, 2==denis full, 3==lindmik
        sampleRate
        secondsPerTile
        minTrackLength
        maxExpectedTrackWidth
        bandwidth
        lowPassFilter
        highPassFilter
        drawSimMat
        compute_confs
        draw_confs
        eta
        solution_shift
        use_costgaussianwidth
        cosine_normalization
        contig_penalty = 0.2
        use_costsymmetry
        costsymmetry_incentivebalance
        use_costcontigpast
        costcontigpast_incentivebalance
        use_costcontigfuture
        costcontigfuture_incentivebalance
        use_costsum
        costsum_incentivebalance
        use_costgaussian
        costgauss_incentivebalance
        use_costcontigevolution
        costevolution_incentivebalance
        costevolution_normalization
        costsum_normalization
        costcontig_normalization
        costsym_normalization
        estimate_tracks = 0;
    end
    
end