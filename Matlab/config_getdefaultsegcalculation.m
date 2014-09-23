function [c] = config_getdefaultsegcalculation()

cfg = load('config/best_trackestimate.mat');

c = cfg.track_estimateconfig;

end

