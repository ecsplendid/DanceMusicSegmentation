function [c] = config_getdefaultsegcalculation()

cfg = load('config/best_trackestimate.mat');


c = cfg.track_estimateconfig;
c.memory_efficient=1;
end

