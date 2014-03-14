function [ matched_tracks, predictions, SC, C, W, w, tileWidthSecs, space ] = process_wavfile( ...
    showname, sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
    drawsimmat, solution_shift, costmatrix_parameter, costmatrix_normalizationtype, ...
    gaussian_filterdegree,cost_transformexponent)

[C, W, tileWidthSecs, space] = get_cosinematrix(...
    audio_low, secondsPerTile, sampleRate,...
    lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
    gaussian_filterdegree );

%C_exp = 1 - ((1-C).^cost_transformexponent);

% minimum track length in tiles
w = floor((minTrackLength)/tileWidthSecs);

SUMC = getcost_sum( C, W, w );
%SYMC = find_symmetrycostmatrix( C_exp, W, w, T );

SUMC = heuristicscale_costmatrix ( costmatrix_normalizationtype, ...
    costmatrix_parameter, SUMC, W );

% normalize it so we dont break wouters assertion in posterior
[predictions, matched_tracks] = compute_trackplacement( ...
        showname, SUMC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C );

SC = SUMC;
    
%%
end
