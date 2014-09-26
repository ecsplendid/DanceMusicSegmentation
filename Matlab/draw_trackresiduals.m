function draw_trackresiduals(agr)
%%


    function  plot_hist(x,plt,lw)
        xr=-10:10;
        h = histc(x,xr);
        h = conv(h,hamming(1),'same');
        plot(xr,h,plt, 'LineWidth',lw);
    end

    plot_hist(agr.track_estimate_errors,'k-',4);
    hold on;

    plot_hist(agr.trackestimate_noveltyerrors,'k--x',5);
    plot_hist(agr.trackestimate_naiveerrors,'k--d',2);
    
    xlabel('Seconds');
    ylabel('Tracks');
    title('Track Errors/Residuals By Method');
    axis square;
    hold off;
    
    legend( ...
        sprintf( 'Our Method (std: %.2f, acc: %d/%d)', ...
            std(agr.track_estimate_errors), ...
            sum(agr.track_estimate_errors==0), length(agr.track_estimate_errors) ), ...
        sprintf( 'Novelty Peak Finding (std: %.2f, acc: %d/%d)', ...
            std(agr.trackestimate_noveltyerrors), sum(agr.trackestimate_noveltyerrors==0), length(agr.trackestimate_noveltyerrors) ), ...
        sprintf( 'Naive Guessing (std: %.2f, acc: %d/%d)', ...
            std(agr.trackestimate_naiveerrors), sum(agr.trackestimate_naiveerrors==0), length(agr.trackestimate_naiveerrors) ) ) ;
    
    grid on

end

%%








