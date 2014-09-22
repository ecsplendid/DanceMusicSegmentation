function f = get_noveltyfunction( ...
    show_results, kernel_size, ...
    min_distance, threshold, draw_plot )
% get_noveltyfunction create a novelty function along the lines suggested
% by foote et al in his papers, run a gaussian tapered checkerboard kernel
% down the diagonal of the cosines matrix. Then do peak finding subject to
% constraints (threshold and minimum radius).
% check out "AUDIO NOVELTY-BASED SEGMENTATION OF MUSIC CONCERTS"
% (Badawy,2013) for a clear run through

if nargin < 2
   kernel_size = 120; 
end

if nargin < 3
   min_distance = 60;
end

if nargin < 3
   threshold = 0.3;
end

if nargin < 4
   draw_plot = 1;
end

%%
C = show_results.show.CosineMatrix;

T = size(C,1);

novelty = nan(T,1);

C(isnan(C)) = 0;

k = kron( [1 -1; -1 1], ones(kernel_size/2,kernel_size/2) );
g = fspecial('gaussian', [kernel_size kernel_size], kernel_size);
g = (g-min(min(g)))./(max(max(g))-min(min(g)));
k = k.*g;

% we need to make a bigger C, zero pad it
% so that we can slide the kernel from start to end
C2 = zeros( size(C)+kernel_size );

C2( floor(kernel_size/2):end-floor(kernel_size/2)-1, ...
    floor(kernel_size/2):end-floor(kernel_size/2)-1 ) = C;

for t=1:T
   
    sq = C2( t:t+kernel_size-1, t:t+kernel_size-1 );
    r = corrcoef(sq, k);
    novelty( t ) = -r(1,2);
end

% normalize onto [0,1] interval
novelty = (novelty - min(novelty)) ./ ...
    ( max(novelty) - min(novelty) );

if draw_plot
    figure(2)
    plot(novelty,'k', 'LineWidth', 2)
    hold on;
end

[ p, f ] = findpeaks( novelty, ...
    'MINPEAKDISTANCE', min_distance );

allowed = p>threshold;

if draw_plot
    % plot the peaks
    plot( f(allowed), p(allowed), 'kx', 'LineWidth', 10 );
    % plot the threshold line
    plot( 1:T, ones(T,1).*threshold, 'k--', 'LineWidth', 2 );

    actual_tilespace = floor( ...
        show_results.show.indexes ./ ...
        show_results.config.secondsPerTile );

    for i=1:length(actual_tilespace)

        plot( [actual_tilespace(i) actual_tilespace(i)], ...
            [ min(novelty) max(novelty) ], 'k:', 'LineWidth', 1 );
    end

    title( sprintf( ...
'Novelty Peak Finding\n Show: %s\nMinimum Peak Distance: %d, Kernel Size: %d, Threshold: %0.1f', ...
        show_results.show.showname, min_distance, kernel_size, threshold ) );

    ylabel( 'Normalized Correlation Coefficient' );
    xlabel('Tiles')

    hold off;
    axis tight
end

f = f(allowed);

end