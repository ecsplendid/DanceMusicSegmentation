clear all;

cd ../dataset 
local_testset
cd ..

config_settings;
cd experiments

while(true)

    ts = [10];
    secondsPerTile = 20;%ts(floor(rand*2)+1);
    
    solution_shift = floor((rand*3)-1);
    solution_shift = 0;
    
    cosine_normalization = rand+0.5;
    contig_windowsize = floor(rand*5+2);
    
use_costsymmetrysum     = rand;        costsymmetrysum_incentivebalance = rand;
use_costsymmetrydiff    = rand;       costsymmetrydiff_incentivebalance = rand;
use_costsymmetry        = rand;           costsymmetry_incentivebalance = rand;
use_costcontigpast      = rand;         costcontigpast_incentivebalance = rand;
use_costcontigfuture    = rand;       costcontigfuture_incentivebalance = rand;
use_costsum             = rand;                costsum_incentivebalance = rand;
use_costgaussian        = rand;              costgauss_incentivebalance = rand;
use_costcontigevolution = rand;          costevolution_incentivebalance = rand;
   
   % bandwidth = floor(rand*10)+1; % bandwith for the width of the convolution filter
   % lowPassFilter = floor(rand*1100)+800; %Hz
   % highPassFilter = floor((rand * 50)+50); %Hz
   
    cd ..
    run_experiments;
    
    name = sprintf('T:%.2fs CN:%.1f BW:%d LPF:%d HPF:%d SFT:%d SS:%.1f@i%.1f SD:%.1f@i%.1f SY:%.1f@i%.1f CP:%.1f@i%.1f CF:%.1f@i%.1f SU:%.1f@i%.1f GA:%.1f@i%.1f CE:%.1f@i%.1f CONT:%d',...
           secondsPerTile, cosine_normalization, bandwidth,lowPassFilter, highPassFilter, solution_shift, ...
            use_costsymmetrysum, costsymmetrysum_incentivebalance, ...
            use_costsymmetrydiff, costsymmetrydiff_incentivebalance, ...
            use_costsymmetry, costsymmetry_incentivebalance, ...
            use_costcontigpast, costcontigpast_incentivebalance, ...
            use_costcontigfuture, costcontigfuture_incentivebalance, ...
            use_costsum, costsum_incentivebalance, ...
            use_costgaussian, costgauss_incentivebalance, ...
            use_costcontigevolution, costevolution_incentivebalance, ...
            contig_windowsize );
    
    
    cd experiments
    save_result;

end
