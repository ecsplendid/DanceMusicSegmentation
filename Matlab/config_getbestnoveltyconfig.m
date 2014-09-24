function c = config_getbestnoveltyconfig(dataset)

if nargin < 1
   dataset = 1; 
end

cfg = load('config/config_novelty-best_24-Sep-2014.mat');

c = cfg.nov_config;
c.memory_efficient = 1;
c.dataset = dataset;

end