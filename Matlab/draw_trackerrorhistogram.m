function draw_trackerrorhistogram(ag)

xr = -10:10;

ma = 0;
mb = 0;

    function [ma, mb, st] = plot_shift(r,plt, ma, mb)
        x = r;
        h = histc(x,xr);
        st = std(r);
        mb = max( mb, max( h ) );
        h = conv(resample_matrix(h,400),hamming(30),'same');
        plot(h,plt)
        ma = max( ma, max( h ) );
        
    end

[ma, mb, stn] = plot_shift(ag.trackestimate_noveltyerrors,'k', ma, mb);

hold on;

[ma, mb, ste] = plot_shift(ag.track_estimate_errors,'k:', ma, mb);
[ma, mb, stnaiv] = plot_shift(ag.trackestimate_naiveerrors,'k--', ma, mb);

legend( ...
    sprintf('Novelty (std: %.2f)', ste ), ...
    sprintf('Our Method (std: %.2f)', stn ), ...
    sprintf('Naive Guessing (std: %.2f)', stnaiv ) ...
    );


title('Track Number Estimation Error');
xlabel('Error (Seconds)');
ylabel('Shows');

set(gca,'XTick',linspace(1,400,20));
set(gca,'XTickLabel',floor(linspace(-10,10,20)));

set(gca,'YTick',linspace(1,ma,20) );
set(gca,'YTickLabel',floor(linspace(1,mb,20)));

axis tight;
hold off;

end

