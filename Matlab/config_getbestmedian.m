function [c] = config_getbestmedian(dataset, extended)

if nargin < 1
   dataset = 1; 
end

if nargin < 2
   extended = 1; 
end

cfg = load('config/best-median.mat');

c = cfg.best_config;

c.drawSimMat = extended;
c.memory_efficient = ~extended;
c.compute_confs = extended;

c.dataset = dataset;

end

