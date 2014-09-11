function [show] = get_cosinematrix(...
    show, cfg )


    no_tiles = ceil((length(show.audio)/cfg.sampleRate)/cfg.secondsPerTile);
    % we discard the last partial tile
    tileWidth = floor(length(show.audio)/no_tiles);
    nFFT = 2^nextpow2( tileWidth );
    %max track width in seconds
    
    downsample = 5000;
    
    show.W =  ceil( cfg.maxExpectedTrackWidth /cfg.secondsPerTile ); 
    lowPassFilterSamples = ceil(cfg.lowPassFilter * ...
        (nFFT/cfg.sampleRate))+1;
    highPassFilterSamples = ceil(cfg.highPassFilter * ...
        (nFFT/cfg.sampleRate))+1;
    assert( lowPassFilterSamples < nFFT/2 );
    fdata = nan( no_tiles, downsample  );
    
	% in FFT steps
    bandw_fftSpace = ( cfg.bandwidth * (nFFT/cfg.sampleRate) ); 
  
    show.w = floor((cfg.minTrackLength) / cfg.secondsPerTile);
                        
    tileindexes = (1:tileWidth);

    % gaussian function
    gauss = @(x, sigma)exp(-x.^2/(2*sigma.^2)) / (sigma*sqrt(2*pi));
    %first order derivative of Gaussian
    dgauss = @(x, sigma)-x .* gauss(x,sigma) / sigma.^2;
    dgfilter = dgauss(-(bandw_fftSpace+10):(bandw_fftSpace+10), ...
        bandw_fftSpace );
    
for x=1:no_tiles

        dft = fft( show.audio( tileindexes+(x-1)*tileWidth ), nFFT );
        
        Y = dft( highPassFilterSamples:lowPassFilterSamples );
        Y = abs(Y);
        
        Y = resample_vector( Y, downsample );
        
        Y = (conv( Y, dgfilter,'same' ));
        
        %normalize (unit length) vec, so dot below gives cosines;
        Y = Y./norm(Y); 

        assert((norm(Y)-1)<1e-6);
        fdata(x, : ) = Y;
end


    show.space = (0:no_tiles-1) .* cfg.secondsPerTile;
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
