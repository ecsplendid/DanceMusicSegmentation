clear all;
load_testmix;
sampleRate = 4000;

shows = [ 1:395 ];

averages = [];
precisions = nan(length(shows),7);

total_tracks = 0;

for tatwshow = 1:length(shows)
    
    tatwshow
 
    indexes = tatw_shows{shows(tatwshow)}.indexes;
    
    audio_low = wavread( tatw_shows{shows(tatwshow)}.file );
    % strip first track (intro)
    strip_seconds = indexes(1);
    % strip off the intro track
    audio_low =  audio_low( ((indexes(1)*sampleRate)):end ); 
    indexes = indexes(2:end);
    indexes = indexes - strip_seconds;
    
    % kill of any indexes less than a minute
    % add on one for the end of the show
    
    tracksize_threshold = 120;
    totalSeconds = floor(length( audio_low)/sampleRate);
    % insert the end time, take diffs, lose any <=120
    indexes = [indexes; totalSeconds];
    indexes = indexes( diff(indexes)>tracksize_threshold ); 
    % is there one too close to zero?
    if indexes(1) < tracksize_threshold
        indexes = indexes(2:end);
    end
    
    total_tracks = total_tracks + length(indexes);
    
    naives = linspace( 1, totalSeconds, length(indexes)+2 );
    naives_final = naives(2:end-1);
    
    averages = [averages; (indexes' - naives_final)'];
    
    [matched_tracks] = evaluate_performance(indexes, naives_final);
    precisions(tatwshow,:) = sum(matched_tracks);
end

%%

hist(averages,50);
mean(abs(averages));
sum(precisions)./total_tracks;

clear audio_low;
save all_naives;
