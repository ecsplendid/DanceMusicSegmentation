function v = config_tovector(config)
%config_tovector turn a config into a vector

v = nan(28,1);

v(1) = config.secondsPerTile;
v(2) = config.minTrackLength;
v(3) = config.maxExpectedTrackWidth;
v(4) = config.bandwidth;
v(5) = config.lowPassFilter;
v(6) = config.highPassFilter;
v(7) = config.solution_shift;
v(8) = config.use_costgaussianwidth;
v(9) = config.cosine_normalization;
v(10) = config.use_costsum;
v(11) = config.costsum_normalization;
v(12) = config.costsum_incentivebalance;
v(13) = config.use_costgaussian;
v(14) = config.costgauss_incentivebalance;
v(15) = config.use_costcontigevolution;
v(16) = config.costevolution_incentivebalance;
v(17) = config.costevolution_normalization;
v(18) = config.costcontig_evolutiondiffwindow;
v(19) = config.use_costcontigpast;
v(20) = config.costcontig_pastdiffwindow;
v(21) = config.costcontigpast_incentivebalance;
v(22) = config.costcontig_normalization;
v(23) = config.use_costcontigfuture;
v(24) = config.costcontig_futurediffwindow;
v(25) = config.costcontigfuture_incentivebalance;
v(26) = config.use_costsymmetry;
v(27) = config.costsymmetry_incentivebalance;
v(28) = config.costsym_normalization;

end