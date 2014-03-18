clear all;

cd ../dataset 
all_shows
cd ..

config_settings;
cd experiments

% EXPERIMENT 1: 111H
use_costsymmetry = 1;
use_costcontig = 1;
use_costsum = 1;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '111H';
cd experiments
save_result;

% EXPERIMENT 2: 110H
use_costsymmetry = 1;
use_costcontig = 1;
use_costsum = 0;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '110H';
cd experiments
save_result;

% EXPERIMENT 3: 101H
use_costsymmetry = 1;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '101H';
cd experiments
save_result;

% EXPERIMENT 4: 011H
use_costsymmetry = 0;
use_costcontig = 1;
use_costsum = 1;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '011H';
cd experiments
save_result;

% EXPERIMENT 5: 001H
use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 1;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '001H';
cd experiments
save_result;


% EXPERIMENT 6: 010H
use_costsymmetry = 0;
use_costcontig = 1;
use_costsum = 0;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '010H';
cd experiments
save_result;

% EXPERIMENT 7: 100H
use_costsymmetry = 1;
use_costcontig = 0;
use_costsum = 0;
use_costgaussian = 0.5;
cd ..
run_experiments;
name = '100H';
cd experiments
save_result;

% EXPERIMENT 8: 0001
use_costsymmetry = 0;
use_costcontig = 0;
use_costsum = 0;
use_costgaussian = 1;
cd ..
run_experiments;
name = '0001';
cd experiments
save_result;
