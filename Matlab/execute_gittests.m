% this is needed to avoid the cryptic bug loading shows
clear all;

cd dataset 
local_testset
cd ..

config_settings;

run_experiments;