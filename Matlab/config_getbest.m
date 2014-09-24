function [c] = config_getbest(dataset, extended)

if nargin < 1
   dataset = 1; 
end

if nargin < 2
   extended = 1; 
end

cfg = load('config/best_mean.mat');

c = cfg.best_config;

c.drawSimMat = extended;
c.memory_efficient = ~extended;
c.compute_confs = extended;

c.dataset = dataset;

end

