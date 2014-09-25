function draw_shifthistogram

xr = -60:60;

    function m = plot_shift(r,plt)
        x = r.agr.shifts;
        h = histc(x,xr);
        h = conv(h,hamming(5),'same');
        plot(xr,h,plt)
        m = max( h );
    end

mx = 0;

r = load('results/agres_all-mean_21-Sep-2014.mat','agr');
mx = max( mx, plot_shift(r,'k') );

hold on;
r = load('results/agres_contig_mean-gauss_22-Sep-2014.mat','agr');
mx = max( mx, plot_shift(r,'k:') );

r = load('results/agres_evo_mean-gauss_22-Sep-2014.mat','agr');
mx = max( mx, plot_shift(r,'k--') );

r = load('results/agres_sum_mean-gauss_22-Sep-2014.mat','agr');
mx = max( mx, plot_shift(r,'k+') );

r = load('results/agres_sym_mean-gauss_21-Sep-2014.mat','agr');
mx = max( mx, plot_shift(r,'k*') );

legend( ...
    sprintf('Mixture' ), ...
    sprintf('Contig-Static' ), ...
    sprintf('Contig-Evolution' ), ...
    sprintf('Summation' ), ...
    sprintf('Symmetry' ) ...
    );

plot( zeros(121,1), linspace( 1, mx, 121 ), 'k', 'LineWidth',2 );

title('Track Error For Mean Score Optimized Cost Matrices');
xlabel('Error (Seconds)');
ylabel('Track Instances');

axis tight;
hold off;

end

