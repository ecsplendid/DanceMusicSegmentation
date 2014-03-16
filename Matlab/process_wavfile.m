function [ avg_shift, matched_tracks, predictions, SC, C, W, w, tileWidthSecs, space ] = process_wavfile( ...
    showname, sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
    drawsimmat, solution_shift, costmatrix_parameter, costmatrix_normalizationtype, ...
    gaussian_filterdegree,cosine_transformexponent, usesymmetry, costmatrix_regularization)

[C, W, tileWidthSecs, space] = get_cosinematrix(...
    audio_low, secondsPerTile, sampleRate,...
    lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
    gaussian_filterdegree, cosine_transformexponent );

%%

% minimum track length in tiles
w = floor((minTrackLength) / tileWidthSecs);

if( usesymmetry )
    SC = getcost_contig( C, W, w );
else
    SC = getcost_sum( C, W, w );
end

SC = SC .^ costmatrix_regularization;

SC = heuristicscale_costmatrix ( costmatrix_normalizationtype, ...
   costmatrix_parameter, SC, W );

% normalize it so we dont break wouters assertion in posterior
[predictions, matched_tracks, avg_shift] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, w );
 
%%
end
