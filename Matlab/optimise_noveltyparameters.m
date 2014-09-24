function [score] = optimise_noveltyparameters( ibev, test_mode )
%optimise_noveltyparameters find the best parameters for the novelty
%function
% learn these 
% 1,novelty_minpeakradius = 10..150 INT
% 2,novelty_threshold = 0.01..1
% 3,novelty_kernelsize = 30..300 INT
% 4,secondsPerTile = 3..40 INT
% 5,bandwidth = 1..15 INT
% 6,cosine_normalization 0.4..1.5
% 7,lpf 800..1950 INT
% 8,hpf 50..500 INT
% 9,solution shift -5..5 INT

if nargin > 1
    ibev = [ 40, 0.3, 120, 20, 5, 0.9, 1400, 50, 0 ];
end

config = config_getbest(1);
    
config.novelty_minpeakradius = (ibev(1));
config.novelty_threshold = ibev(2);
config.novelty_kernelsize = (ibev(3));
config.secondsPerTile = (ibev(4));
config.bandwidth = (ibev(5));
config.cosine_normalization = (ibev(6));
config.lowPassFilter = (ibev(7));
config.highPassFilter = (ibev(8));
config.novelty_solutionshift = (ibev(9));
config.memory_efficient = 1;
config.estimate_tracks = 0;
config.drawSimMat = 0;
    
base_conf = config_getdefault;
base_conf.secondsPerTile=40;
base_conf.use_costsymmetry        = 0;       
base_conf.use_costcontigpast      = 0;     
base_conf.use_costcontigfuture    = 0;   
base_conf.use_costsum             = 0;    
base_conf.use_costgaussian        = 0;           
base_conf.use_costcontigevolution = 0; 
base_conf.estimate_tracks=0;
base_conf.memory_efficient=1;
base_conf.drawSimMat=0;

ag = run_experiments( ...
        base_conf, 'opt', ...
        [], ...
        config );
    
score = -sum( ag.F1Score_Novelty );

end