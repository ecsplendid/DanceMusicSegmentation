clear all;

cd ../dataset 
local_testset
cd ..

config_settings;
cd experiments

for i=1:1000

    use_costsymmetry = rand * 2;
    use_costcontig = rand * 2;
    use_costsum = rand * 2;
    use_costgaussian = rand * 2;
    
    solution_shift = 0;
    
    if( rand > 0.7 ) 
        solution_shift = floor(rand * 10)-5;
    end
    
    costsymmetry_incentivebalance = rand;
    costcontig_incentivebalance = rand;
    costsum_incentivebalance = rand;
    costgauss_incentivebalance = rand;
    
    bandwidth = floor((rand*10)+3); % bandwith for the width of the convolution filter
    lowPassFilter = floor(rand*1000)+500; %Hz
    highPassFilter = (rand*300)+50; %Hz
    
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

secondsPerTile = 10;

while(true)
    
      use_costsymmetry = rand * 2;
    use_costcontig = rand * 2;
    use_costsum = rand * 2;
    use_costgaussian = rand * 2;
    
    solution_shift = 0;
    
    if( rand > 0.7 ) 
        solution_shift = floor(rand * 10)-5;
    end
    
    costsymmetry_incentivebalance = rand;
    costcontig_incentivebalance = rand;
    costsum_incentivebalance = rand;
    costgauss_incentivebalance = rand;
    
    bandwidth = floor((rand*10)+3); % bandwith for the width of the convolution filter
    lowPassFilter = floor(rand*1000)+500; %Hz
    highPassFilter = (rand*300)+50; %Hz
    
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