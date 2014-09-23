
run_experiments( ...
    config_getbest(1), ...
    'best mean with track estimation', ...
    config_getdefaultsegcalculation );

[tpf, fpf] = draw_roccurve( r, 0 );

plot(fpf,'k');

[tpf, fpf]= draw_roccurve( r, 1 );

hold on;
plot(fpf,'k:');

[tpf, fpf]= draw_roccurve( r, 2 );
plot(fpf,'k--');

[tpf, fpf]= draw_roccurve( r, 3 );
plot(fpf,'r--');

legend( 'Our Method', 'Novelty Peak Finding', ...
    'Guessing', 'Ours (Track Estimated)' );

hold off;


