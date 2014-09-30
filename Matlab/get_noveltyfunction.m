function f = get_noveltyfunction( ...
    show, config, draw_plot, ...
    maximum_indices, min_distance, threshold )
% get_noveltyfunction create a novelty function along the lines suggested
% by foote et al in his papers, run a gaussian tapered checkerboard kernel
% down the diagonal of the cosines matrix. Then do peak finding subject to
% constraints (threshold and minimum radius).
% check out "AUDIO NOVELTY-BASED SEGMENTATION OF MUSIC CONCERTS"
% (Badawy,2013) for a clear run through

kernel_size = config.novelty_kernelsize;


if nargin < 3
   draw_plot = 1;
end

if nargin < 4
    maximum_indices = 999;
end

if nargin < 5
    min_distance = config.novelty_minpeakradius;
end

if nargin < 6
    threshold = config.novelty_threshold;
end

%% kernel size must be even
if mod( kernel_size, 2 ) ~= 0
    kernel_size = kernel_size - 1;
end


%%
C = show.CosineMatrix;

T = size(C,1);

novelty = nan(T,1);

C(isnan(C)) = 0;

%%
k = kron( [1 -1; -1 1], ones(kernel_size/2,kernel_size/2) );
g = fspecial('gaussian', [kernel_size kernel_size], kernel_size);
g = (g-min(min(g)))./(max(max(g))-min(min(g)));
k = k.*g;
k(k<0)=0;
%%
% we need to make a bigger C, zero pad it
% so that we can slide the kernel from start to end
C2 = zeros( size(C)+kernel_size );

C2( floor(kernel_size/2)+1:end-floor(kernel_size/2), ...
    floor(kernel_size/2)+1:end-floor(kernel_size/2) ) = C;

for t=1:T
   
    sq = C2( t:t+kernel_size-1, t:t+kernel_size-1 );
    r = corrcoef(sq, k);
    novelty( t ) = -r(1,2);
end

% normalize onto [0,1] interval
novelty = (novelty - min(novelty)) ./ ...
    ( max(novelty) - min(novelty) );

if draw_plot
    figure(9)
    plot(novelty,'k', 'LineWidth', 2)
    hold on;
end

[ p, f ] = findpeaks( novelty, ...
    'MINPEAKDISTANCE', min_distance, ...
    'MINPEAKHEIGHT', threshold, ...
    'NPEAKS', maximum_indices ...
    );

% there should be no track indices at start or end
% we are helping the novelty function along here
% as it's a tricky start overlapping onto the zero padded matrix
% this is only fair as I have a minimum track width parameter
edge_margintiles = floor( 120 / config.secondsPerTile );

 % over the threshold (superflous now because of MINPEAKHEIGHT)
allowed = p > threshold ...
            & f>edge_margintiles ... % not too close to start
            & f<(T-edge_margintiles); % not too close to end

if draw_plot
    % plot the peaks
    plot( f(allowed), p(allowed), 'kx', 'LineWidth', 10 );
    % plot the threshold line
    plot( 1:T, ones(T,1).*threshold, 'k--', 'LineWidth', 2 );

    actual_tilespace = floor( ...
        show.indexes ./ ...
        config.secondsPerTile );

    for i=1:length(actual_tilespace)

        plot( [actual_tilespace(i) actual_tilespace(i)], ...
            [ min(novelty) max(novelty) ], 'k:', 'LineWidth', 1 );
    end

s1=sprintf('Novelty Peak Finding, Show: %s', ...
      show.showname );
s2=sprintf('Minimum Peak Distance: %d Kernel Size: %d Tile Size: %d Threshold: %0.1f', ...
    min_distance, kernel_size,config.secondsPerTile, threshold );
s3=sprintf('Cosine Normalization: %0.1f, lpf: %d hpf: %d Shift: %d Bandwidth: %d', ...
     config.cosine_normalization, config.lowPassFilter, ...
     config.highPassFilter, config.solution_shift, config.bandwidth );

    title( sprintf( '%s\n%s\n%s', s1, s2, s3 ) );

    ylabel( 'Normalized Correlation Coefficient' );
    xlabel('Tiles')

    hold off;
    axis tight
end

%put it in time space and perform the shift
f = show.space( f(allowed) ) + config.novelty_solutionshift;

end