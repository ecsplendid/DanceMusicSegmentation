function draw_fscores(ag_results, save_fig)
%results_drawfpcurves draw f scores for all modes

if nargin < 1
   save_fig=0; 
end

    plot(ag_results.F1Score_Ours.Scores,'k');

    hold on;
    plot(ag_results.F1Score_OursEstimated.Scores,'k+');
    plot(ag_results.F1Score_Novelty.Scores,'r');
    plot(ag_results.F1Score_Guesses.Scores,'k--');
    plot(ag_results.F1Score_NoveltyNoRadius.Scores,'b:');
   
    
    legend( 'Our Algorithm','Our Algorithm (Track # Estimated)', ...
         'Novelty Peak Finding', ...
        'Guessing', 'Novelty No Radius' ...
         );
    ylabel('F-Measure');
    xlabel('Threshold (Seconds)');
    title('F_1 Score Method Comparison Over Time Thresholds');

    hold off;
    axis tight;
    
    if save_fig==1
        c=clock;
        savefig( sprintf('results/fig_fscores_%s%d%d.fig', ...
            date, c(4), c(5) ) );
    end
end
