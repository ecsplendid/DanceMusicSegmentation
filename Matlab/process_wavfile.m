function [ avg_shift, matched_tracks, predictions, SC, C, W, min_w, tileWidthSecs, space ] = process_wavfile( ...
    showname, sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
    drawsimmat, solution_shift, ...
    gaussian_filterdegree,cosine_transformexponent, costmatrix_regularization, ...
    use_costsymmetry, use_costcontig, use_costsum, use_costgaussian, use_costgaussianwidth, contig_symmetrythreshold, ...
      sum_regularization, ...
    costcontig_incentivebalance, costsum_incentivebalance, costsymmetry_incentivebalance, ...
    costgauss_incentivebalance )


[C, W, tileWidthSecs, space] = get_cosinematrix(...
    audio_low, secondsPerTile, sampleRate,...
    lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
    gaussian_filterdegree, cosine_transformexponent );

%%

% minimum track length in tiles
min_w = floor((minTrackLength) / tileWidthSecs);
T = size(C,1);

if( use_costcontig > 0 )
    SC_CONTIG = getcost_contig( ...
        C, W, min_w, contig_symmetrythreshold, ...
         costcontig_incentivebalance ...
        ) .* use_costcontig;
    SC = SC_CONTIG;
end

if( use_costsum > 0 )
    
    SC_SUM = ((getcost_sum( C, W, min_w, sum_regularization, ...
         costsum_incentivebalance ) .* use_costsum))-(use_costsum/2);
    
    if( use_costcontig > 0 )
        
        SC = SC + SC_SUM;
    else
      SC = SC_SUM;
      
    end
end

if( use_costsymmetry > 0 )
    
    SC_SYM = ((getcost_symmetry( C, W, min_w, contig_symmetrythreshold, ...
             costsymmetry_incentivebalance ) ...
            .* use_costsymmetry))-(use_costsymmetry/2);
        
    if( use_costcontig > 0 || use_costsum > 0 )
       
        SC = SC + SC_SYM;
    else
        SC = SC_SYM;
    end
end

if( use_costgaussian > 0 )
    
    SC_GAUSS = getcost_gaussian( T, W, min_w, costgauss_incentivebalance, ...
        use_costgaussian, use_costgaussianwidth );
    
    if( use_costcontig > 0 || use_costsum > 0 || use_costsymmetry > 0 )
        
        SC = SC + SC_GAUSS;
    else
        SC = SC_GAUSS;
    end
end

SC = SC .^ costmatrix_regularization;

SC = normalize_costmatrix(SC);



% normalize it so we dont break wouters assertion in posterior
[predictions, matched_tracks, avg_shift] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, min_w );
 
%%
end
