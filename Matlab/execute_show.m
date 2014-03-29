
if( exist('execute_config') && execute_config ), config_settings, end;

%config_settings;

show = shows{which_shows(s)};

indexes = show.indexes; 
chops = show.chops;
tic;

audio_low = audioread( show.file );

global showname;

showname = strrep(show.file, '_', ' ');
showname = strrep(showname, 'examples/', '');
showname = strrep(showname, '.wav', '');

fprintf( 'Current Show: %s\n', show.file );

chopper =  true( size( audio_low ) ) ;

    % chop out the intros from the show
    for ch=1:size( chops, 1 )

        %get from and to in samples (stored in minutes)
        from = max(1,ceil(chops(ch,1)*sampleRate));
        to = ceil(chops(ch,2)*sampleRate);

        chopper( from:to ) = 0;
    end

    audio_low = audio_low(chopper);
    clear chopper;
    
    M = length(indexes);

    %SC == song cost matrix, C = 1-cosine matrix, W=max trach width in
    %tiles w=min track width in tiles
    [ avg_shift, matched_tracks_fft, predictions, SC, C, W, min_w, space ] = ...
        process_wavfile( showname, sampleRate, indexes, audio_low, secondsPerTile, ...
            minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
            drawsimmat, solution_shift, gaussian_filterdegree, ...
            use_costsymmetrysum, use_costsymmetrydiff, use_costsymmetry, ...
            use_costcontigpast, use_costcontigfuture, use_costsum, use_costgaussian, ...
            costsymmetrysum_incentivebalance, costsymmetry_incentivebalance, ...
            costcontigfuture_incentivebalance, costcontigpast_incentivebalance, ...
            costsymmetrydiff_incentivebalance, costsum_incentivebalance, costgauss_incentivebalance,  ...
            use_costcontigevolution, costevolution_incentivebalance, ...
            use_cosinecache, contig_windowsize, use_costgaussianwidth, cosine_normalization );

    clear audio_low;

    thresholds(s,:) = (sum(matched_tracks_fft)./length(indexes)) .* 100;
    avg_trackerror = mean(abs(indexes' - predictions))

    heuristicaccuracy = get_heuristicaccuracy( indexes, predictions );
    
    heuristic_loss(s) = heuristicaccuracy;
    average_loss( s ) = avg_trackerror;
    median_loss( s ) = median(abs(indexes' - predictions));
    average_shifts(s) = avg_shift;
    
    shifts = [ shifts; (predictions - indexes')' ];
    
    predictive_quality = resample_vector( abs(indexes' - predictions), output_width );
    predictive_loss_noabs( s, : ) = resample_vector( (indexes' - predictions), output_width );

    if( compute_confs )
    
        [mean_indexplacementconfidence, worst_indexplacementconfidence, ...
        track_indexconfidences, track_placementconfidence, track_placementconfidenceavg] = ...
        find_posterior( SC, M, eta, draw_confs, output_width, showname );

        track_placementconfidences_map( s, : ) = track_placementconfidence;
        track_placementconfidenceavg_map ( s ) = track_placementconfidenceavg;
        track_indexconfidences_map( s, : ) = track_indexconfidences;
        worst_indexplacementconfidence_map( s ) = worst_indexplacementconfidence;
        mean_indexplacementconfidence_map( s ) = mean_indexplacementconfidence;
        predictive_loss( s,: ) = predictive_quality;
    end
    
    toc;

