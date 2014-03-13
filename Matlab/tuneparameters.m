
clear all
load_testmix
sampleRate = 4000;
%%

shows = [ 1:30 ];

best_sofar = inf;

all_data = [];

while true

averages = nan(length(shows),1);
precisions = nan(length(shows),7);

errors = [];

% random parameters
secs = 1:25;
filts = 1:20;
mins = [2 3 4];

secondsPerTile = secs( round( rand * (length(secs)-1) )+1 )
minTrackLength = 60*mins( round( rand * (length(mins)-1) )+1 )
maxExpectedTrackWidth = round(60*7 + 60*rand*6 )
bandwidthFilter = filts( round( rand * (length(filts)-1) )+1 )%Hz
lowPassFilter = round(1000+(rand*900))%Hz
highPassFilter = round(70+(rand*800));
windowoverlapconcept = 0;
curve_size = 0;
curve_scale = 0;
curve_shift = 0;
trackspershow = zeros(length(tatw_shows),1);

for tatwshow = 1:length(shows)
    
    indexes = tatw_shows{shows(tatwshow)}.indexes;

    [audio_low fs bits] = wavread( tatw_shows{shows(tatwshow)}.file );

    % strip first track (intro)
    strip_seconds = indexes(1);
    % strip off the intro track

    audio_low = audio_low( ((indexes(1)*sampleRate)):end ); 

    indexes = indexes(2:end);
    indexes = indexes - strip_seconds;
    
    % kill of any indexes less than a minute
    % these are probably intros
    tracksize_threshold = 120;
    totalSeconds = floor(length( audio_low)/sampleRate);
    % insert the end time, take diffs, lose any <=120
    indexes = [indexes; totalSeconds];
    indexes = indexes( diff(indexes)>tracksize_threshold ); 
    % is there one too close to zero?
    if indexes(1) < tracksize_threshold
        indexes = indexes(2:end);
    end
    
    try
        tic;
        [ matched_tracks_fft predictions ] = ...
        processAudioFile(sampleRate, indexes,  audio_low, secondsPerTile, ...
        minTrackLength, maxExpectedTrackWidth, bandwidthFilter, ...
        lowPassFilter, highPassFilter, windowoverlapconcept, ...
       curve_size, curve_scale, curve_shift, 0, 0, ...
        0, 0 );
        
        toc;
    catch
       continue; 
    end

    clear audio_low
    
    errors = [errors; (indexes' - predictions)'];
    
    avg_trackerror = mean(abs(indexes' - predictions));
    
    averages(tatwshow) = avg_trackerror;
    precisions(tatwshow,:) = sum(matched_tracks_fft);
    
    trackspershow(shows(tatwshow)) = length(indexes);
    
    tatwshow

    %stem(indexes' - predictions)
end



metricselection = ~isnan(averages);
%stem((indexes' - predictions)')

%hist(errors,150)

%% 

total_tracks = sum(trackspershow(metricselection));

if size(precisions(metricselection,:),1) > 1 

    precs = [60,30,20,10,5,3,1 ; (sum(precisions(metricselection,:))./total_tracks).*100]';

else
    precs =   [60,30,20,10,5,3,1 ; ( precisions(metricselection,:)./total_tracks).*100]';
end

thisresult = mean(averages)

if thisresult < best_sofar
   
    save ( sprintf('params/res_%0.5g.mat',thisresult ) );
    best_sofar = thisresult;
end

all_data = [secondsPerTile minTrackLength maxExpectedTrackWidth bandwidthFilter lowPassFilter ...
   highPassFilter thisresult precs(1) precs(2) precs(3) precs(4) precs(5) precs(6) precs(7) ]

save all_data.txt 'all_data' -ASCII -append

end



