clear all;

cd ../dataset 
all_shows
cd ..

config_settings;
cd experiments

tile_sizes = [20 10];

for i=1:length(tile_sizes)

    secondsPerTile = tile_sizes(i);

    A;
    cd ..
    run_experiments;
    name = sprintf('A_T%d',secondsPerTile);
    cd experiments
    save_result;
    
    B;
    cd ..
    run_experiments;
    name = sprintf('B_T%d',secondsPerTile);
    cd experiments
    save_result;

    C;
    cd ..
    run_experiments;
    name = sprintf('C_T%d',secondsPerTile);
    cd experiments
    save_result;
    
    D;
    cd ..
    run_experiments;
    name = sprintf('D_T%d',secondsPerTile);
    cd experiments
    save_result;
    
    E;
    cd ..
    run_experiments;
    name = sprintf('E_T%d',secondsPerTile);
    cd experiments
    save_result;
    
    A_nogauss;
    cd ..
    run_experiments;
    name = sprintf('A_nogauss_T%d',secondsPerTile);
    cd experiments
    save_result;
    
    B_nogauss;
    cd ..
    run_experiments;
    name = sprintf('B_nogauss_T%d',secondsPerTile);
    cd experiments
    save_result;

    C_nogauss;
    cd ..
    run_experiments;
    name = sprintf('C_nogauss_T%d',secondsPerTile);
    cd experiments
    save_result;
    
    D_nogauss;
    cd ..
    run_experiments;
    name = sprintf('D_nogauss_T%d',secondsPerTile);
    cd experiments
    save_result;

end

% run a D (only SUM/gauss) which is fast, at 5 secs for comparison

secondsPerTile = 5;

D;
cd ..
run_experiments;
name = sprintf('D__T%d',secondsPerTile);
cd experiments
save_result;