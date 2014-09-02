function [show] = get_cosinematrix(...
    show, cfg )

    no_tiles = ceil((length(show.audio)/cfg.sampleRate)/cfg.secondsPerTile);
    tileWidth = floor(length(show.audio)/no_tiles); % we discard the last partial tile
    nFFT = 2^nextpow2( tileWidth );
    show.tileWidthSecs = tileWidth/cfg.sampleRate;
    %max track width in seconds
    
    show.W =  ceil((cfg.maxExpectedTrackWidth)/show.tileWidthSecs); 
    lowPassFilterSamples = ceil(cfg.lowPassFilter * (nFFT/cfg.sampleRate))+1;
    highPassFilterSamples = ceil(cfg.highPassFilter * (nFFT/cfg.sampleRate))+1;
    assert( lowPassFilterSamples < nFFT/2 );
    fdata = nan( no_tiles, (lowPassFilterSamples-highPassFilterSamples)+1  );
    bandw_fftSpace = ( cfg.bandwidth * (nFFT/cfg.sampleRate) ); % in FFT steps
    gaussParams=-ceil(2*bandw_fftSpace):ceil(2*bandw_fftSpace);
    gaussFirstDerivative = -exp(- ...
        gaussParams.^cfg.gaussian_filterdegree/bandw_fftSpace^2) ...
                            .* (2*gaussParams/bandw_fftSpace^2);

    show.w = floor((cfg.minTrackLength) / show.tileWidthSecs);
                        
    tileindexes = (1:tileWidth);

for x=1:no_tiles

        dft = fft( show.audio( tileindexes+(x-1)*tileWidth ),nFFT);
        
        Y = abs(dft);
        Y = Y( highPassFilterSamples:lowPassFilterSamples );
        Y = abs(conv(  Y, gaussFirstDerivative,'same' ));
        %normalize (unit length) vec, so dot below gives cosines;
        Y = Y./norm(Y); 

        assert((norm(Y)-1)<1e-6);
        fdata(x, : ) = Y;
end
 
    show.space = (0:no_tiles-1) .* show.tileWidthSecs;
    %%
    %thrown an abs in there in case of any numerical error on the low costs
    C = (abs((1-(fdata * fdata'))));
    
    % so now we expect C to be on [0,1] (cosines)
     
    % C is normally distributed but scewed in some random way depending on
    % music
    % We can normalize it around 0.5 which means we can expect more
    % consistent behaviour with our methods. It will stay on [0,1]
    % which is a bonus
    
    mean_c = mean(C(1:size(C,1)^2));
    show.CosineMatrix=C.^(2*mean_c);

    % perform the parameterised cosine normalization 
    show.CosineMatrix = show.CosineMatrix.^cfg.cosine_normalization;
    
    % scale to [1,2], then translate to [-1,1]
    show.CosineMatrix = (show.CosineMatrix.*2)-1; 
    
    show.T = size(C,1);
    
end