function [c] = config_getbest()

cfg = load('config/best_mean.mat');

c = cfg.best_config;

end

