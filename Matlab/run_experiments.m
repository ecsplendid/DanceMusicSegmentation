clear all;
%tatw_script_extended;
%magic_script_extended;
%asot_script_extended;

cd dataset 
local_testset
cd ..

which_shows = 1:length(shows);

which_shows = 1;

howmany_shows = length(which_shows);

output_width = 100;
   
sampleRate = 4000;
    
track_indexconfidences_map = zeros( howmany_shows, output_width );
track_placementconfidences_map = zeros( howmany_shows, output_width );
track_placementconfidenceavg_map = zeros( howmany_shows, 1 );
worst_indexplacementconfidence_map = zeros( howmany_shows, 1 );
mean_indexplacementconfidence_map = zeros( howmany_shows, 1 );
predictive_loss = nan( howmany_shows, output_width );
predictive_loss_noabs = nan( howmany_shows, output_width );

heuristic_loss = nan(howmany_shows,1);
average_loss = nan( howmany_shows, 1 );
median_loss = nan( howmany_shows, 1 );
thresholds = nan( howmany_shows,7 );
average_shifts = nan(howmany_shows, 1);

global drawsimmat;

%% set parameters

    secondsPerTile = 10;
    minTrackLength = 180;
    maxExpectedTrackWidth = 580;%370*2;  %% magicisland=380*2 others 350*2
    bandwidth = 5;%Hz
    lowPassFilter = 1400;%Hz
    highPassFilter = 200;%Hz
    gaussian_filterdegree = 2;
    cosine_transformexponent = 1;
    
    % 1, favor short tracks, 2 long tracks, 3 add gauss, 4 multiply gauss
    
    costmatrix_parameter = 0.2;
    costmatrix_normalizationtype = 0; 
    costmatrix_regularization = 1;
    eta = 10;
    drawsimmat = 1;
    draw_confs = 0;
    solution_shift = 0;
    usesymmetry = 1;


%%

for s=1:howmany_shows; 
 
    execute_show;

end

fprintf('mean=%.2f, heuristic=%.2f shiftavg=%.2f', ...
    mean(average_loss), mean(heuristic_loss), mean(average_shifts) )

if( howmany_shows > 1 )
    mean(thresholds)
else
    thresholds
end
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