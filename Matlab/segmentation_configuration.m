classdef segmentation_configuration
    % all the config properties can be encapsulated in this class so that
    % they can be passed around to other functions easily without having
    % to resort to global variables
    
    properties
        sampleRate
        secondsPerTile
        minTrackLength
        maxExpectedTrackWidth
        bandwidth
        lowPassFilter
        highPassFilter
        gaussian_filterdegree
        drawSimMat
        compute_confs
        draw_confs
        use_cosinecache
        eta
        solution_shift
        use_costgaussianwidth
        cosine_normalization
        contig_windowsize
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
    end
    
end