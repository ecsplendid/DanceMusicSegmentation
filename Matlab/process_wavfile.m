function [ avg_shift, matched_tracks, predictions, SC, C, W, min_w, space ] = process_wavfile( ...
    showname, sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
    drawsimmat, solution_shift, ...
    gaussian_filterdegree, ...
    use_costsymmetry, use_costcontig, use_costsum, use_costgaussian, use_costgaussianwidth, ...
    costcontig_incentivebalance, costsum_incentivebalance, costsymmetry_incentivebalance, ...
    costgauss_incentivebalance, use_cosinecache)

global map;

if( use_cosinecache )
        
    if(~exist('map'))
       map = containers.Map; 
    end
    
    id = sprintf('%d%d%d%d%d', length(audio_low), ...
        secondsPerTile, lowPassFilter, highPassFilter, bandwidth );
end

if ( use_cosinecache && map.isKey(id) )
    cache = map(id);
    C = cell2mat(cache(1));
    tileWidthSecs = cell2mat(cache(2));
    space = cell2mat(cache(3));
    W = cell2mat(cache(4));
else
    % todo, cache the "last" 6 things this was called with to give a 
    % big speed up on the parameter search
    [C, W, tileWidthSecs, space] = get_cosinematrix(...
        audio_low, secondsPerTile, sampleRate,...
        lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
        gaussian_filterdegree );

    if( use_cosinecache )
        map(id) = {C,tileWidthSecs, space, W };
    end
end



%%

% minimum track length in tiles
min_w = floor((minTrackLength) / tileWidthSecs);
T = size(C,1);

if( use_costcontig > 0 )
    SC_CONTIG = getcost_contig( ...
        C, W, min_w, ...
         costcontig_incentivebalance ...
        ) .* use_costcontig;
    SC = SC_CONTIG;
end

if( use_costsum > 0 )
    
    SC_SUM = ((getcost_sum( C, W, min_w, ...
         costsum_incentivebalance ) .* use_costsum));
    
    if( use_costcontig > 0 )
        
        SC = SC + SC_SUM;
    else
      SC = SC_SUM;
      
    end
end

use_referenceversion = 1;

if( use_costsymmetry > 0 )
    
    if(use_referenceversion)
    	SC_SYM = (getcost_symmetry_reference( C, W, min_w, costsymmetry_incentivebalance ) ...
            .* use_costsymmetry);
    else
        SC_SYM = (getcost_symmetry( C, W, min_w, costsymmetry_incentivebalance ) ...
            .* use_costsymmetry);
    end
    
    if( use_costcontig > 0 || use_costsum > 0 )
       
        SC = SC + SC_SYM;
    else
        SC = SC_SYM;
    end
end

if( use_costgaussian > 0 )
    
    SC_GAUSS = getcost_gaussian( T, W, min_w, ...
        use_costgaussian, use_costgaussianwidth, costgauss_incentivebalance ) ...
        .* use_costgaussian;
    
    if( use_costcontig > 0 || use_costsum > 0 || use_costsymmetry > 0 )
        
        SC = SC + SC_GAUSS;
    else
        SC = SC_GAUSS;
    end
end

% normalize it so we dont break wouters assertion in posterior
[predictions, matched_tracks, avg_shift] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, min_w, ...
        secondsPerTile, use_costsymmetry, use_costcontig, use_costsum, use_costgaussian, ...
        costcontig_incentivebalance, costsum_incentivebalance, costsymmetry_incentivebalance, costgauss_incentivebalance );
 
%%
end
