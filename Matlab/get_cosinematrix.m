function [C, W, tileWidthSecs, space, T, w] = get_cosinematrix(...
    audio_low, cfg )

    no_tiles = ceil((length(audio_low)/cfg.sampleRate)/cfg.secondsPerTile);
    tileWidth = floor(length(audio_low)/no_tiles); % we discard the last partial tile
    nFFT = 2^nextpow2( tileWidth );
    tileWidthSecs = tileWidth/cfg.sampleRate;
    %max track width in seconds
    W =  ceil((cfg.maxExpectedTrackWidth)/tileWidthSecs); 
    lowPassFilterSamples = ceil(cfg.lowPassFilter * (nFFT/cfg.sampleRate))+1;
    highPassFilterSamples = ceil(cfg.highPassFilter * (nFFT/cfg.sampleRate))+1;
    assert( lowPassFilterSamples < nFFT/2 );
    fdata = nan( no_tiles, (lowPassFilterSamples-highPassFilterSamples)+1  );
    bandw_fftSpace = ( cfg.bandwidth * (nFFT/cfg.sampleRate) ); % in FFT steps
    gaussParams=-ceil(2*bandw_fftSpace):ceil(2*bandw_fftSpace);
    gaussFirstDerivative = -exp(- gaussParams.^cfg.gaussian_filterdegree/bandw_fftSpace^2) ...
                            .* (2*gaussParams/bandw_fftSpace^2);

    w = floor((cfg.minTrackLength) / tileWidthSecs);
                        
    tileindexes = (1:tileWidth);

for x=1:no_tiles

        dft = fft( audio_low( tileindexes+(x-1)*tileWidth ),nFFT);
        
        Y = abs(dft);
        Y = Y( highPassFilterSamples:lowPassFilterSamples );
        Y = abs(conv(  Y, gaussFirstDerivative,'same' ));
        %normalize (unit length) vec, so dot below gives cosines;
        Y = Y./norm(Y); 

        assert((norm(Y)-1)<1e-6);
        fdata(x, : ) = Y;
end
 
    space = (0:no_tiles-1) .* tileWidthSecs;
    %%
    %thrown an abs in there in case of any numerical error on the low costs
    C = (abs((1-(fdata * fdata'))));
     
    % C is normally distributed but scewed in one direction 
    % depending on some unknown, perhaps our side, perhaps the underlying
    % music. We can normalize it around 0.5 which means we can expect more
    % consistent behaviour with our methods
    
    mean_c = mean(C(1:size(C,1)^2));
    C=C.^(2*mean_c);

    T = size(C,1);
    
end