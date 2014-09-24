function [F1,F2,F3,F4] = results_drawfpcurves(ag_results)
%results_drawfpcurves draw f scores for all modes, return them
% mode 0: our predictions
% mode 1: novelty function
% mode 2: guesses
% this currently runs slow as hell, needs optimization

    [F1] = results_fscore( ag_results, 0 );

    plot(F1,'k');

    [F2] = results_fscore( ag_results, 1 );

    hold on;
    plot(F2,'k:');
    [F3] = results_fscore( ag_results, 2 );
    plot(F3,'k--');

    [F4] = results_fscore( ag_results, 3 );
    plot(F4,'k+');

    legend( 'Our Method', 'Novelty Peak Finding', ...
        'Guessing', 'Our Method (Track # Estimated)' );
    ylabel('F-Measure');
    xlabel('Threshold (Seconds)');
    title('F_1 Score Method Comparison Over Thresholds');

    hold off;
    
    c=clock;
    
    savefig( sprintf('results/fig_fscores_%s%d%d.fig', ...
        date, c(4), c(5) ) );


end