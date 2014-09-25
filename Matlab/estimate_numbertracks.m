function [results] = estimate_numbertracks( ...
    show, results, config )
% estimate_numbertracks will run the find_tracks for all m_i in {14,...,25}
% and report the number of tracks at the minima of result/m_i and also report
% the absolute sum of differences of the results which can be used as a confidence measure

    how_many = 30;
    best_results = nan(how_many,1);

    ntiles = size(show.CostMatrix,1);
    
    for i=ceil(ntiles/show.W):mean([ceil(ntiles/show.w),ceil(ntiles/show.W)])

        [F, ~] = find_tracks( i, show.CostMatrix );

        best_results(i) = F/i;
    end

    [~, index] = min(best_results);
    
    if config.drawSimMat==1
        figure(1)
subplot(2,5,[10]);
        
        plot(best_results,'k:');
        hold on;

        plot(length(show.indexes)+1, best_results(length(show.indexes)+1),'*k');
        plot(index, best_results(index),'+k');
        hold off;
        title(strcat(show.showname,''));
        xlabel('Number Of Tracks')
        ylabel('Sum cost normalized by number tracks');
        axis square;

        legend('cost curve', ...
            sprintf('actual (%d)', length(show.indexes)+1), ...
            sprintf('minima (%d)', index ))
       % exportfig(gcf,sprintf('%d_tracks.eps', show.number) );
    end

    results.convexity_estimate = ...
        min( abs( diff( best_results(~isnan(best_results)) ) ) );
    results.track_estimate = index;
    
    results.track_estimate_error = ...
        results.track_estimate - (length(show.indexes)+1);
       
end
