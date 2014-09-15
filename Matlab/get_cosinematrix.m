function [show] = get_cosinematrix(...
    show, cfg )

% we discard the last partial tile
T = floor((length(show.audio)/cfg.sampleRate)/cfg.secondsPerTile);

tileWidthSamples = cfg.secondsPerTile * cfg.sampleRate;

nFFT = 2^nextpow2( tileWidthSamples );
%max track width in seconds

show.T = T;
show.W =  ceil( cfg.maxExpectedTrackWidth /cfg.secondsPerTile ); 
lowPassFilterSamples = ceil(cfg.lowPassFilter * ...
    (nFFT/cfg.sampleRate))+1;
highPassFilterSamples = ceil(cfg.highPassFilter * ...
    (nFFT/cfg.sampleRate))+1;
assert( lowPassFilterSamples < nFFT/2 );

% in FFT steps
bandw_fftSpace = ( cfg.bandwidth * (nFFT/cfg.sampleRate) ); 
show.w = floor((cfg.minTrackLength) / cfg.secondsPerTile);

% gaussian function
gauss = @(x, sigma)exp(-x.^2/(2*sigma.^2)) / (sigma*sqrt(2*pi));
% first order derivative of Gaussian
dgauss = @(x, sigma)-x .* gauss(x,sigma) / sigma.^2;
dgfilter = dgauss(-(bandw_fftSpace+10):(bandw_fftSpace+10), ...
    bandw_fftSpace );

if show.use_gpu
    show.audio = gpuArray( show.audio );
end

fft_limit = 13000;
    
% perform fft and convolution on GPU
% note that if tile size is high highPassFilterSamples:lowPassFilterSamples
% will be very large and doing these operations will take longer, so after
% the convolution (afterwards because the bandwidth must make sense) we
% resample it down if its more than fft_limit samples (basically 
% never happens unless seconds per tile > 10).

persistent fft_cache;

if isempty(fft_cache) && cfg.use_persistentvariables == 1 
    fft_cache = cell(100,6);
end

if cfg.use_persistentvariables ~= 1 ...
        || ( isempty(fft_cache{cfg.secondsPerTile, show.number}) ...
        && ~isempty(fft_cache) )
         
    square = reshape( ...
        show.audio( 1:T*tileWidthSamples ), ...
        tileWidthSamples, T )';
    
    adata = abs( fft( square, nFFT, 2));
    
    if cfg.use_persistentvariables ~= 1
        fft_cache{cfg.secondsPerTile, show.number} = adata;
    end
else
    adata = fft_cache{cfg.secondsPerTile, show.number};
end


adata = adata( :, highPassFilterSamples:lowPassFilterSamples );
adata = conv2( adata, dgfilter,'same' );

if size(adata,2) > fft_limit
   adata = resample_matrix( adata, fft_limit );
end

adata = adata ./ repmat( sqrt(sum( abs(adata).^2,2 )), 1, size(adata,2) );

show.space = (0:T-1) .* cfg.secondsPerTile;

% for a performance speed up we break the data into segments
% and do D*D' from Segment X --> X+ahead so that we can 
% skip some unused parts of the cosine matrix i.e. it's not
% relevant how similar the first track is to the last track
segs = 10;
C = nan( T, T );

if show.use_gpu
    C = gpuArray(C);
end

pts = floor(linspace(1,T,segs));

ahead = 2;

means = zeros(segs,1);

if show.use_gpu
    means = gpuArray(means);
end

for s=1:segs-ahead
    S = adata( pts(s):pts(s+ahead), : );
    Cp = ((S*S'));
    C( pts(s):pts(s+ahead), pts(s):pts(s+ahead) ) = gather(Cp);
    means(s) = mean( mean( Cp ) );
end

% so now we expect C to be on [-1,1] (cosines)

% scale to [0,1]
C = (C - min(min(C))) ./ max( max( C(~isinf(C)) ) - min( min( C ) ) );

% change to dis-similarities
C = 1-C;

% C is normally distributed but scewed in some random way depending on
% music
% We can normalize it around 0.5 which means we can expect more
% consistent behaviour with our methods. It will stay on [0,1]

mean_c = mean(means);

% scale mean to [0,1] from [-1,1]
mean_c =  (mean_c + 1) / 2;

for s=1:segs-ahead
    C(pts(s):pts(s+ahead)) = C(pts(s):pts(s+ahead)).^(2*mean_c);
end

% perform the parameterised cosine normalization 
C = C.^cfg.cosine_normalization;

% scale to [1,2], then translate to [-1,1]
C = (C.*2)-1; 

show.CosineMatrix = gather(C);

show.T = size(C,1);

end
