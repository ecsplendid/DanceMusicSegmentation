
s = execute_show(1, config_getbest(1,1));

%%

r = -1:0.1:1;
h = histc( ...
    s.show.CosineMatrix(1:size(s.show.CosineMatrix,1)^2), ...
    r );
h = resample_matrix(h,1000);
h = conv( h, hamming(100),'same' );


plot( linspace(-1,1,1000), h, 'k', 'LineWidth', 4)

title('Cosine Matrix Histogram, Normalization = 0.7');
xlabel('Value');
ylabel('Number of Cells');
axis square;
grid on;
exportfig(gcf,'figures/cosine_histogram.eps');