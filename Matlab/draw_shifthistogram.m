function draw_shifthistogram

xr = -60:60;

    function m = plot_shift(r,plt, lws, lw)
        x = r.residuals_ourmethod_all;
        h = histc(x,xr);
        h = conv(h,hamming(5),'same');
        
        h =h./size(r.mean_all,2)
        
        plot(xr,h,plt, lws, lw)
        m = max( h );
    end

mx = 0;

r = load('results/agres_mean_all_28-Sep-2014','agr');
mx = max( mx, plot_shift(r.agr.lindmik,'k', 'LineWidth', 3) );
hold on;
r = load('results/agres_mean_all_28-Sep-2014','agr');
mx = max( mx, plot_shift(r.agr.magic,'k', 'LineWidth', 2) );

r = load('results/agres_mean_all_28-Sep-2014','agr');
mx = max( mx, plot_shift(r.agr.tatw,'k:', 'LineWidth', 3) );

r = load('results/agres_mean_all_28-Sep-2014','agr');
mx = max( mx, plot_shift(r.agr.asot,'k:', 'LineWidth', 3 ) );


legend( ...
    sprintf('LINDMIK' ), ...
    sprintf('MAGIC' ), ...
    sprintf('TATW' ), ...
    sprintf('ASOT' ) ...
    );


% r = load('results/Phase 5/agres_contig_mean-gauss_22-Sep-2014.mat','agr');
% mx = max( mx, plot_shift(r,'k:') );
% 
% r = load('results/Phase 5/agres_evo_mean-gauss_22-Sep-2014.mat','agr');
% mx = max( mx, plot_shift(r,'k--') );
% 
% r = load('results/Phase 5/agres_sum_mean-gauss_22-Sep-2014.mat','agr');
% mx = max( mx, plot_shift(r,'k+') );
% 
% r = load('results/Phase 5/agres_sym_mean-gauss_21-Sep-2014.mat','agr');
% mx = max( mx, plot_shift(r,'k*') );
% 
% legend( ...
%     sprintf('Mixture' ), ...
%     sprintf('Contig-Static' ), ...
%     sprintf('Contig-Evolution' ), ...
%     sprintf('Summation' ), ...
%     sprintf('Symmetry' ) ...
%     );

plot( zeros(121,1), linspace( 0, mx, 121 ), 'k', 'LineWidth',2 );

title('Track Error For Mean Score Optimized Cost Matrices');
xlabel('Error (Seconds)');
ylabel('Normalized Track Instances');
axis square;
axis tight;
hold off;
grid on;

exportfig(gcf,'figures/residuals_byshow.eps');

end

