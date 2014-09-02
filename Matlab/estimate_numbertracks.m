function [index] = estimate_numbertracks( ...
    SC, showname, indexes, config )

    how_many = 30;
    results = nan(how_many,1);

    for i=14:30

        [F, ~] = find_tracks( i, SC );

        results(i) = F/i;
    end

    [~, index] = min(results);
    
    if config.drawSimMat==1
        figure(6)
        plot(results,'k:');
        hold on;

        plot(length(indexes)+1, results(length(indexes)+1),'*r');
        plot(index, results(index),'+b');
        hold off;
        title(strcat(showname(1:46),'...'));
        xlabel('Number Of Tracks')
        ylabel('Sum cost normalized by number tracks');
        axis square;

        legend('cost curve','actual','minima')
       % exportfig(gcf,sprintf('%d_tracks.eps',2));
    end

end