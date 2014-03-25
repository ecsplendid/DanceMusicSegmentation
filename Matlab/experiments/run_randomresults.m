clear all;

cd ../dataset 
local_testset
cd ..

config_settings;
cd experiments

while(true)

    ts = [5 10 20];
    secondsPerTile = ts(floor(rand*3)+1);
    
    use_costsymmetry = rand
    use_costcontig = rand;
    use_costsum = rand;
    use_costgaussian = rand;
    
    solution_shift = 0;
    
    costsymmetry_incentivebalance = rand;
    costcontig_incentivebalance = rand;
    costsum_incentivebalance = rand;
    costgauss_incentivebalance = rand;
    
    
    bandwidth = floor(rand*10)+1; % bandwith for the width of the convolution filter
    lowPassFilter = floor(rand*1100)+800; %Hz
    highPassFilter = floor((rand * 50)+50); %Hz
    
    cd ..
    run_experiments;
    name = sprintf( 'T%d SY%.1f CO%.1f SU%.1f GA%.1f SYIB%.1f COIB%.1f SUIB%.1f GAIB%.1f BW%.1f LP%.1f HP%.1f SS%d', ...
        secondsPerTile, use_costsymmetry,use_costcontig,use_costsum,use_costgaussian,...
        costsymmetry_incentivebalance,costcontig_incentivebalance,...
        costsum_incentivebalance,costgauss_incentivebalance, ...
        bandwidth,lowPassFilter, highPassFilter, solution_shift );
    cd experiments
    save_result;

end