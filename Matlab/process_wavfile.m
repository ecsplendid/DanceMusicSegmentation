function [ avg_shift, matched_tracks, predictions, SC, C, W, min_w, space, T ] = process_wavfile( ...
            showname, sampleRate, indexes, audio_low, secondsPerTile, ...
            minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
            drawsimmat, solution_shift, gaussian_filterdegree, ...
            use_costsymmetrysum, use_costsymmetrydiff, use_costsymmetry, ...
            use_costcontigpast, use_costcontigfuture, use_costsum, use_costgaussian, ...
            costsymmetrysum_incentivebalance, costsymmetry_incentivebalance, ...
            costcontigfuture_incentivebalance, costcontigpast_incentivebalance, ...
            costsymmetrydiff_incentivebalance, costsum_incentivebalance, costgauss_incentivebalance,  ...
            use_costcontigevolution, costevolution_incentivebalance, ...
            use_cosinecache, contig_windowsize, use_costgaussianwidth, cosine_normalization )

global map;
global maps_used;
global maps_lastindex;
global map_initialized;
global map_limit;    

if( use_cosinecache && isempty(map_initialized) )
    
    map = containers.Map; 
    maps_lastindex = 1;
    map_initialized = 1;
    map_limit = 15;
    maps_used = cell(map_limit,1);
end

id = sprintf('%d%d%d%d%d', length(audio_low), ...
    secondsPerTile, lowPassFilter, highPassFilter, bandwidth );

if ( use_cosinecache && map.isKey(id) )
    cache = map(id);
    C = cell2mat(cache(1));
    tileWidthSecs = cell2mat(cache(2));
    space = cell2mat(cache(3));
    W = cell2mat(cache(4));
    disp( sprintf('USED CACHED COSINE MATRIX!\n%s',id ));
else
    % todo, cache the "last" 6 things this was called with to give a 
    % big speed up on the parameter search
    [C, W, tileWidthSecs, space] = get_cosinematrix(...
        audio_low, secondsPerTile, sampleRate,...
        lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
        gaussian_filterdegree, cosine_normalization );

    clear audio_low;
    
    if( use_cosinecache )
        map(id) = {C,tileWidthSecs, space, W };
        maps_lastindex = maps_lastindex + 1;
        if( map.isKey(maps_used{maps_lastindex}) )
            map.remove( maps_used{maps_lastindex} );
        end
        maps_used{maps_lastindex} = id;
        if( maps_lastindex>map_limit)
            maps_lastindex = 1;
        end
    end
end

% do the cosine normalization (out here so its not cached)

C = C.^cosine_normalization;

% we do the normalization manually to keep it centered
C = (C.*2)-1; 


%%

% minimum track length in tiles
min_w = floor((minTrackLength) / tileWidthSecs);
T = size(C,1);

SC = zeros( T, W );

if( use_costcontigevolution > 0 )
    
    SC = SC + getcost_contigdiag1( ...
        C, W, min_w, ...
         costevolution_incentivebalance ...
        ) .* use_costcontigevolution;   
end

if( use_costsymmetrysum > 0 )
    
    SC = SC + getcost_symmetrysum( ...
        C, W, min_w, ...
         costsymmetrysum_incentivebalance ...
        ) .* use_costsymmetrysum;   
end

if( use_costsymmetrydiff > 0 )
    
    SC = SC + getcost_symmetrydiff( ...
        C, W, min_w, ...
         costsymmetrydiff_incentivebalance ...
        ) .* use_costsymmetrydiff;   
end

if( use_costsymmetry > 0 )
    
    SC = SC + getcost_symmetry3( ...
        C, W, min_w, ...
         costsymmetry_incentivebalance ...
        ) .* use_costsymmetry;   
end

if( use_costcontigfuture > 0 )
    
    SC = SC + getcost_contigstatic( ...
        C, W, min_w, ...
         costcontigfuture_incentivebalance, contig_windowsize, 1 ...
        ) .* use_costcontigfuture;   
end

if( use_costcontigpast > 0 )
    
    SC = SC + getcost_contigstatic( ...
        C, W, min_w, ...
         costcontigpast_incentivebalance, contig_windowsize, 0 ...
        ) .* use_costcontigpast;   
end

if( use_costgaussian > 0 )
    
    SC = SC + getcost_gaussian( T, W, min_w, ...
        use_costgaussian, use_costgaussianwidth, costgauss_incentivebalance ) ...
        .* use_costgaussian;
    
end

if( use_costsum > 0 )
    
    SC = SC + (getcost_sum3( C, W, min_w, costsum_incentivebalance ) .* use_costsum);

end

[predictions, matched_tracks, avg_shift] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, min_w, ...
        secondsPerTile, use_costsymmetrysum, use_costsymmetrydiff, use_costsymmetry, ...
            use_costcontigpast, use_costcontigfuture, use_costsum, use_costgaussian, ...
            costsymmetrysum_incentivebalance, costsymmetry_incentivebalance, ...
            costcontigfuture_incentivebalance, costcontigpast_incentivebalance, ...
            costsymmetrydiff_incentivebalance, costsum_incentivebalance, ...
            costgauss_incentivebalance, use_costcontigevolution, ...
            costevolution_incentivebalance, contig_windowsize, cosine_normalization );
 
%%
end
