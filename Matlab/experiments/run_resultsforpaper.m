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
    cd experiments
    save_result( sprintf('A_T%d',secondsPerTile), average_loss, ...
        heuristic_loss, average_shifts );

    B;
    cd ..
    run_experiments;
    cd experiments
    save_result( sprintf('B_T%d',secondsPerTile), average_loss, ...
        heuristic_loss, average_shifts );
    
    C;
    cd ..
    run_experiments;
    cd experiments
    save_result( sprintf('C_T%d',secondsPerTile), average_loss, ...
        heuristic_loss, average_shifts );
    
    D;
    cd ..
    run_experiments;
    cd experiments
    save_result( sprintf('D_T%d',secondsPerTile), average_loss, ...
        heuristic_loss, average_shifts );
    
    E;
    cd ..
    run_experiments;
    cd experiments
    save_result( sprintf('E_T%d',secondsPerTile), average_loss, ...
        heuristic_loss, average_shifts );

end