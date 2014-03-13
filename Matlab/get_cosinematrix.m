function [C, W, tileWidthSecs, space] = get_cosinematrix(...
    audio_low, secondsPerTile, ...
    sampleRate, ...
    lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, gaussian_filterdegree )

    no_tiles = ceil((length(audio_low)/sampleRate)/secondsPerTile);
    tileWidth = floor(length(audio_low)/no_tiles); % we discard the last partial tile
    nFFT = 2^nextpow2( tileWidth );
    tileWidthSecs = tileWidth/sampleRate;
    %max track width in seconds
    W =  ceil((maxExpectedTrackWidth)/tileWidthSecs); 
    lowPassFilterSamples = ceil(lowPassFilter * (nFFT/sampleRate))+1;
    highPassFilterSamples = ceil(highPassFilter * (nFFT/sampleRate))+1;
    assert( lowPassFilterSamples < nFFT/2 );
    fdata = nan( no_tiles, (lowPassFilterSamples-highPassFilterSamples)+1  );
    bandw_fftSpace = ( bandwidth * (nFFT/sampleRate) ); % in FFT steps
    gaussParams=-ceil(2*bandw_fftSpace):ceil(2*bandw_fftSpace);
    gaussFirstDerivative = -exp(- gaussParams.^gaussian_filterdegree/bandw_fftSpace^2) ...
                            .* (2*gaussParams/bandw_fftSpace^2);

    tileindexes = (1:tileWidth);

    for x=1:no_tiles

        dft = fft( audio_low( tileindexes+(x-1)*tileWidth ),nFFT);

        Y = abs(dft( highPassFilterSamples:lowPassFilterSamples ));
        Y = abs(conv(  Y, gaussFirstDerivative,'same' ));
        %normalize (unit length) vec, so dot below gives cosines;
        Y = Y./norm(Y); 

        assert((norm(Y)-1)<1e-6);
        fdata(x, : ) = Y;
    end

    space = (0:no_tiles-1) .* tileWidthSecs;

    C = 1-(fdata * fdata');
   

end