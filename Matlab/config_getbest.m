function [c] = config_getbest(dataset)

if nargin < 1
   dataset = 1; 
end

cfg = load('config/best_mean.mat');

c = cfg.best_config;
c.dataset = dataset;

end

