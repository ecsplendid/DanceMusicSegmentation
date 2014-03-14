function [ matched_tracks, predictions, SC, C, W, w, tileWidthSecs, space ] = process_wavfile( ...
    showname, sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
    drawsimmat, solution_shift, costmatrix_parameter, costmatrix_normalizationtype, ...
    gaussian_filterdegree,cost_transformexponent, usesymmetry, costmatrix_regularization)

[C, W, tileWidthSecs, space] = get_cosinematrix(...
    audio_low, secondsPerTile, sampleRate,...
    lowPassFilter, highPassFilter, bandwidth, maxExpectedTrackWidth, ...
    gaussian_filterdegree );

%%
cost_transformexponent = 1;
C_exp = 1 - ((1-C).^cost_transformexponent);

% minimum track length in tiles
w = floor((minTrackLength)/tileWidthSecs);

SUMC = getcost_sum( C_exp, W, w );
CONC = getcost_contig( C_exp, W, w );
SYMC = getcost_symmetry( C_exp, W, w );

SC = (CONC);

%SC = ( (CONC) + (SUMC) );

costmatrix_regularization = 1;

SC = SC.^costmatrix_regularization;


costmatrix_normalizationtype=2;
costmatrix_parameter = 0.2;

 % SC = 1-( (1-SYMC) + (1-SUMC) );
 
if ( usesymmetry )
    
     
else
   % SC = SUMC;
end

%SC = heuristicscale_costmatrix ( costmatrix_normalizationtype, ...
 %  costmatrix_parameter, SC, W );

% normalize it so we dont break wouters assertion in posterior
[predictions, matched_tracks] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C_exp, w );


    
%%
end
