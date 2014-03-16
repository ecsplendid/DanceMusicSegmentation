clear all;

cd ../dataset 
all_shows
cd ..

config_settings;
cd experiments

tile_sizes = [30 20 10];

for i=1:length(tile_sizes)

    secondsPerTile = tile_sizes(i);

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

secondsPerTile = 5;

A;
cd ..
run_experiments;
name = sprintf('A__T%d',secondsPerTile);
cd experiments
save_result;