function results_drawfpcurves(ag_results)


    [F] = draw_roccurve( ag_results, 0 );

    plot(F,'k');

    [F] = draw_roccurve( ag_results, 1 );

    hold on;
    plot(F,'k:');
    [F] = draw_roccurve( ag_results, 2 );
    plot(F,'k--');

    [F] = draw_roccurve( ag_results, 3 );
    plot(F,'k+');

    legend( 'Our Method', 'Novelty Peak Finding', ...
        'Guessing', 'Our Method (Track # Estimated)' );
    ylabel('F-Measure');
    xlabel('Threshold (Seconds)');
    title('F_1 Score Method Comparison Over Thresholds');

    hold off;


end