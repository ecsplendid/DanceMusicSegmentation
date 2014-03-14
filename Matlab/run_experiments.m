clear all;
%tatw_script_extended;
%magic_script_extended;
%asot_script_extended;

cd dataset 
local_testset
cd ..

which_shows = 1:length(shows);
howmany_shows = length(which_shows);

howmany_shows = 1;

output_width = 100;
   
sampleRate = 4000;
    
track_indexconfidences_map = zeros( howmany_shows, output_width );
track_placementconfidences_map = zeros( howmany_shows, output_width );
track_placementconfidenceavg_map = zeros( howmany_shows, 1 );
worst_indexplacementconfidence_map = zeros( howmany_shows, 1 );
mean_indexplacementconfidence_map = zeros( howmany_shows, 1 );
predictive_loss = nan( howmany_shows, output_width );
predictive_loss_noabs = nan( howmany_shows, output_width );
average_loss = nan( howmany_shows, 1 );
median_loss = nan( howmany_shows, 1 );
thresholds = nan( howmany_shows,7 );

%%

for s=1:howmany_shows; 

    %%
    show = shows{which_shows(s)};

    indexes = show.indexes; 
    chops = show.chops;
    tic;

    audio_low = audioread( show.file );

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

        M = length(indexes);

        secondsPerTile = 10;
        minTrackLength = 180;
        maxExpectedTrackWidth = 370*2;  %% magicisland=380*2 others 350*2
        bandwidth = 5;%Hz
        lowPassFilter = 1000;%Hz
        highPassFilter = 300;%Hz
        gaussian_filterdegree = 2;
        
        cost_transformexponent = 4;
        costmatrix_parameter = 0.5;
        costmatrix_normalizationtype = 3; % 1, favor short tracks, 2 long tracks, 3 gauss
        eta = 10;
        drawsimmat = 1;
        draw_confs = 0;
        solution_shift = 0;
        
        %SC == song cost matrix, C = 1-cosine matrix, W=max trach width in
        %tiles w=min track width in tiles
        [ matched_tracks_fft, predictions, SC, C, W, w, tileWidthSecs, space ] = ...
            process_wavfile( showname, sampleRate, indexes, audio_low, secondsPerTile, ...
                minTrackLength, maxExpectedTrackWidth, bandwidth, lowPassFilter, highPassFilter, ...
                drawsimmat, solution_shift, costmatrix_parameter, costmatrix_normalizationtype, ...
                gaussian_filterdegree, cost_transformexponent);
           
        audio_low = nan;

        thresholds(s,:) = (sum(matched_tracks_fft)./length(indexes)) .* 100;
        avg_trackerror = mean(abs(indexes' - predictions))
        
        average_loss( s ) = avg_trackerror;
        median_loss( s ) = median(abs(indexes' - predictions));
        
        predictive_quality = resample_vector( abs(indexes' - predictions), output_width );
        
        predictive_loss_noabs( s, : ) = resample_vector( (indexes' - predictions), output_width );
        
        [mean_indexplacementconfidence, worst_indexplacementconfidence, ...
            track_indexconfidences, track_placementconfidence, track_placementconfidenceavg] = ...
            find_posterior( SC, M, eta, draw_confs, output_width, showname );
        
        track_placementconfidences_map( s, : ) = track_placementconfidence;
        track_placementconfidenceavg_map ( s ) = track_placementconfidenceavg;
        track_indexconfidences_map( s, : ) = track_indexconfidences;
        worst_indexplacementconfidence_map( s ) = worst_indexplacementconfidence;
        mean_indexplacementconfidence_map( s ) = mean_indexplacementconfidence;
        predictive_loss( s,: ) = predictive_quality;
        
        toc;

end

fprintf('mean=%.2f, median=%.2f\n', mean(average_loss), median(average_loss) )

mean(thresholds)

%%


if( draw_confs && size( predictive_loss,1 )>1 )

    predictive_loss_normalised = sum(predictive_loss);
    predictive_loss_normalised = predictive_loss_normalised - min(predictive_loss_normalised);
    predictive_loss_normalised = predictive_loss_normalised ./max(predictive_loss_normalised);
    predictive_performance_normalised =  1-predictive_loss_normalised;

    track_placementconfidences_map_normalised = sum(track_placementconfidences_map);
    track_placementconfidences_map_normalised = track_placementconfidences_map_normalised - min(track_placementconfidences_map_normalised);
    track_placementconfidences_map_normalised = track_placementconfidences_map_normalised./max(track_placementconfidences_map_normalised);

    track_indexconfidences_map_normalised = sum(track_indexconfidences_map);
    track_indexconfidences_map_normalised = track_indexconfidences_map_normalised - min(track_indexconfidences_map_normalised);
    track_indexconfidences_map_normalised = track_indexconfidences_map_normalised ./ max(track_indexconfidences_map_normalised);

    if( draw_confs )
        figure(12)
        plot( ( predictive_performance_normalised ),'b' );
        hold on;
        plot( ( track_placementconfidences_map_normalised ),'r' );
        plot( ( track_indexconfidences_map_normalised ),'k' );
        hold off;
        legend('performance','time confidence','index confidence')
        title('Comparative performance over the whole data set')
    end

end