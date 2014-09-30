
s = get_allshows(config_getbest(2))


plot_p = {'k','k:','k','k--'};
stds = nan(5,1);
stdst = nan(5,1);

notracks = nan(5,1);
tracklength = nan(5,1);

for sh=1:4

    show_lengths = [];

    show_lengths2 = [];
    
    for i=1:339
        in = show_getindex(lower(s{i}.file));

        if in == sh

            show_lengths = [ show_lengths; ...
                diff( s{i}.indexes ) ];
            
            show_lengths2 = [show_lengths2; length(s{i}.indexes)];
        end
    end
    
    stds(sh) = std(show_lengths);
    stdst(sh) = std(show_lengths2);
    
    notracks(sh) = sum(show_lengths2);
    tracklength(sh) = mean(show_lengths);
    
    h = histc( show_lengths, 110:640 );
    h = conv( h, hamming(60), 'same' );
    
    figure(1);
    plot( 110:640, h, plot_p{sh}, 'LineWidth', sh+1 );
    hold on;
    
    figure(2);
    h2 = histc(show_lengths2, 1:50);
    h2 = conv( h2, hamming(5), 'same' );
    plot( 1:50, h2, plot_p{sh}, 'LineWidth', sh+1 );
    hold on;

end

figure(1);
legend( ...
    sprintf( 'ASOT (std: %.1f)', stds(1) ), ...
    sprintf( 'MAGIC (std: %.1f)', stds(2) ), ...
    sprintf( 'TATW (std: %.1f)', stds(3) ), ...
    sprintf( 'LINDMIK (std: %.1f)', stds(4) ) ...
    );

hold off;
axis tight;
grid on;
axis square;
xlabel('Seconds');
ylabel('Track Instances');
title('Track Length Histogram');

    figure(2);
    hold off;
    axis square;
    title('Number Of Tracks By Dataset')
    legend( ...
    sprintf( 'ASOT (std: %.1f)', stdst(1) ), ...
    sprintf( 'MAGIC (std: %.1f)', stdst(2) ), ...
    sprintf( 'TATW (std: %.1f)', stdst(3) ), ...
    sprintf( 'LINDMIK (std: %.1f)', stdst(4) ) ...
    );

xlabel('Number of Tracks');
ylabel('Number of Shows');
grid on;