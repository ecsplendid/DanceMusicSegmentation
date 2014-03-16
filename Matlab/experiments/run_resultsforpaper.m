clear all;

cd ../dataset 
all_shows
cd ..

config_settings;
cd experiments

tile_sizes = [30 20 10 5];

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
end