clear all;

cd ../dataset 
local_testset
cd ..

config_settings;
cd experiments

while(true)

    use_costsymmetry = rand * 4;
    use_costcontig = rand * 4;
    use_costsum = rand * 4;
    use_costgaussian = rand * 4;
    
    solution_shift = 0;
    
    costsymmetry_incentivebalance = rand;
    costcontig_incentivebalance = rand;
    costsum_incentivebalance = rand;
    costgauss_incentivebalance = rand;
    
    bws = [3 5];
    
    bandwidth = bws(floor(rand*2)+1); % bandwith for the width of the convolution filter
    lowPassFilter = floor(rand*1100)+800; %Hz
    highPassFilter = 80; %Hz
    
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
