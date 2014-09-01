function [index] = estimate_numbertracks( draw_fig, SC, showname, indexes )

    how_many = 30;
    results = nan(how_many,1);

    for i=10:30

        [F, ~] = find_tracks( i, SC );

        results(i) = F;
    end

    if draw_fig
        figure(6)
        plot(results,'k:');
        hold on;

        [~, index] = min(results);
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