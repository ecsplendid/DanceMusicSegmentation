function [ avg_shift, matched_tracks, predictions, SC, C, W, w, tileWidthSecs, space ] = process_wavfile( ...
    showname, sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
    drawsimmat, solution_shift, ...
    gaussian_filterdegree,cosine_transformexponent, costmatrix_regularization, ...
    use_costsymmetry, use_costcontig, use_costsum, use_costgaussian, use_costgaussianwidth, contig_symmetrythreshold, ...
    contig_regularization, symmetry_regularization, sum_regularization, ...
    costcontig_incentivebalance, costsum_incentivebalance, costsymmetry_incentivebalance )


[C, W, tileWidthSecs, space] = get_cosinematrix(...
    audio_low, secondsPerTile, sampleRate,...
    lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
    gaussian_filterdegree, cosine_transformexponent );

%%

% minimum track length in tiles
w = floor((minTrackLength) / tileWidthSecs);

if( use_costcontig > 0 )
    SC_CONTIG = getcost_contig( ...
        C, W, w, contig_symmetrythreshold, ...
        contig_regularization, costcontig_incentivebalance ...
        ) .* use_costcontig;
    SC = SC_CONTIG;
end

if( use_costsum > 0 )
    
    if( use_costcontig > 0 )
        
     SC_SUM = ((getcost_sum( C, W, w, sum_regularization, ...
         costsum_incentivebalance ) .* use_costsum))-(use_costsum/2);
        
     SC = SC + SC_SUM;
     SC = normalize_costmatrix( SC );
    else
      SC = getcost_sum( C, W, w, sum_regularization, ...
          costsum_incentivebalance ) .* use_costsum;
    end
end

if( use_costsymmetry > 0 )
    if( use_costcontig > 0 || use_costsum > 0 )
        SC_SYM = ((getcost_symmetry( C, W, w, contig_symmetrythreshold, ...
            symmetry_regularization, costsymmetry_incentivebalance ) ...
            .* use_costsymmetry))-(use_costsymmetry/2);
        SC = SC + SC_SYM;
        SC = normalize_costmatrix( SC );
    else
        SC = getcost_symmetry( C, W, w, contig_symmetrythreshold, ...
            symmetry_regularization, costsymmetry_incentivebalance) ...
            .* use_costsymmetry;  
    end
end

if( use_costgaussian > 0 )
    if( use_costcontig > 0 || use_costsum > 0 || use_costsymmetry > 0 )
        
         SC_GAUSS = ...
            repmat( (( ( (1-gausswin(W, use_costgaussianwidth)).* use_costgaussian) ) -use_costgaussian )',...
            size(SC,1), 1  );
        
        SC = SC + SC_GAUSS;
        SC = normalize_costmatrix( SC );
    else
         SC = repmat( (( ( (1-gausswin(W, use_costgaussianwidth)).* use_costgaussian) ) )',...
            size(C,1), 1  );
    end
    
    SC(:,1:w) = inf;
end

SC = SC .^ costmatrix_regularization;

% normalize it so we dont break wouters assertion in posterior
[predictions, matched_tracks, avg_shift] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, w );
 
%%
end
