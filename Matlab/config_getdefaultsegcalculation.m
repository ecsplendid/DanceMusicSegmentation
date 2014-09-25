function [c] = config_getdefaultsegcalculation(draw)

cfg = load('config/best_trackestimate.mat');

if nargin < 1
   draw = 0; 
end

c = cfg.track_estimateconfig;
c.memory_efficient=1;
c.drawSimMat = draw;
end

