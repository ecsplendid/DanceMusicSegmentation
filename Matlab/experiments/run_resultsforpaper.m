clear all;

cd ../dataset 
all_shows
cd ..

config_settings;
cd experiments

% EXPERIMENT 1: 1110
use_costsymmetry = 1;
use_costcontig = 1;
use_costsum = 1;
use_costgaussian = 0;
cd ..
run_experiments;
name = '1110_t10';
cd experiments
save_result;

% EXPERIMENT 2: 1100
use_costsymmetry = 1;
use_costcontig = 1;
use_costsum = 0;
use_costgaussian = 0;
cd ..
run_experiments;
name = '1100_t10';
cd experiments
save_result;

% EXPERIMENT 3: 1010
use_costsymmetry = 1;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 0;
cd ..
run_experiments;
name = '1010_t10';
cd experiments
save_result;

% EXPERIMENT 4: 0110
use_costsymmetry = 0;
use_costcontig = 1;
use_costsum = 1;
use_costgaussian = 0;
cd ..
run_experiments;
name = '0110_t10';
cd experiments
save_result;

% EXPERIMENT 5: 001[0.5]
use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '001-05_t10';
cd experiments
save_result;


% EXPERIMENT 6: 0100
use_costsymmetry = 0;
use_costcontig = 1;
use_costsum = 0;
use_costgaussian = 0;
cd ..
run_experiments;
name = '0100_t10';
cd experiments
save_result;

% EXPERIMENT 7: 1000
use_costsymmetry = 1;
use_costcontig = 0;
use_costsum = 0;
use_costgaussian = 0;
cd ..
run_experiments;
name = '1000_t10';
cd experiments
save_result;

% EXPERIMENT 8: 0001
use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 0;
use_costgaussian = 1;
cd ..
run_experiments;
name = '0001_t10';
cd experiments
save_result;


use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 0.5;
secondsPerTile = 2;
cd ..
run_experiments;
name = '00105_t2';
cd experiments
save_result;