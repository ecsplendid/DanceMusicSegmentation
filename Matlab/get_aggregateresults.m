function [agg_results] = get_aggregateresults( ...
        description, results, ...
        config, show_type, ...
        f_scores )

if nargin < 3

	% 0 == no filter, default
	% 1 == a state of trance ONLY
	% 2 == magic island, ONLY
	% 3 == trance around the world, ONLY
    % 4 == LINDMIK, ONLY
	show = 0;
end

if nargin < 5
    f_scores = 0;
end

agg_results = aggregate_results();

agg_results.description = description;

switch( show_type )
    case 1
        agg_results.description = strcat(agg_results.description , ' ASOT');
    case 2
        agg_results.description = strcat(agg_results.description , ' MAGIC');
    case 3
        agg_results.description = strcat(agg_results.description , ' TATW');
    case 4
        agg_results.description = strcat(agg_results.description , ' LINDMIK');
end

agg_results.config = config;

assert(~isempty(results));

width = size(results(1).track_placementconfidence,1);

if( config.compute_confs )

	agg_results.track_placementconfidence_sum = ...
	zeros( width, 1 );
	agg_results.track_indexconfidences_sum = ...
	zeros( width, 1 );
end

function si = gsi(s)
	if ~isempty(strfind(s,'state')) 
		si=1;
	elseif ~isempty(strfind(s,'around'))
		si=3;
    	elseif ~isempty(strfind(s,'magic'))
		si=2;
        elseif ~isempty(strfind(s,'lindmik'))
		si=4;
    	else 
		si = 5;
	end
end

agg_results.convexity_estimate = 0;

for i=1:length(results)
		
	r = results(i);

	if show_type ~= gsi(r.show.showname) && show_type ~= 0
		continue;
    end
    
    agg_results.convexity_estimate = ...
        agg_results.convexity_estimate ...
        + r.convexity_estimate;
    
	agg_results.mean_all = [agg_results.mean_all r.mean_score];
	agg_results.heuristic_all = ...
	[agg_results.heuristic_all r.heuristic_score];
	agg_results.shifts = [agg_results.shifts r.shifts];
    
	agg_results.track_estimate_errors = ...
	[agg_results.track_estimate_errors r.track_estimate_error];
	agg_results.results = [agg_results.results r];
    
    agg_results.trackestimate_naiveerrors = ...
	[agg_results.trackestimate_naiveerrors r.trackestimate_naiveerror];
    
    agg_results.trackestimate_noveltyerrors = ...
        [ agg_results.trackestimate_noveltyerrors ...
            r.trackestimate_noveltyerror ];

	if( config.compute_confs )

		agg_results.track_placementconfidenceavg_all = ...
		[agg_results.track_placementconfidenceavg_all ...
		r.track_placementconfidenceavg];

		agg_results.mean_indexplacementconfidence_all = ...
		[agg_results.mean_indexplacementconfidence_all ...
		r.mean_indexplacementconfidence ];  

		agg_results.track_placementconfidence_sum = ...
		agg_results.track_placementconfidence_sum + ...
		r.track_placementconfidence;

		agg_results.track_indexconfidences_sum = ...
		agg_results.track_indexconfidences_sum + ...
		r.track_indexconfidences;

	end
end

agg_results.global_errormean = mean(abs(agg_results.shifts));
agg_results.global_errormedian = median(abs(agg_results.shifts));
agg_results.global_errorstd = std(agg_results.shifts);

agg_results.convexity_estimate = ...
    agg_results.convexity_estimate / length(results);

agg_results.track_placementconfidenceavg_mean = ...
mean(agg_results.track_placementconfidenceavg_all);
agg_results.mean_indexplacementconfidence_mean = ...
mean(agg_results.mean_indexplacementconfidence_all);

agg_results.mean_overall = mean(agg_results.mean_all);
agg_results.heuristic_meanoverall = mean(agg_results.heuristic_all);
agg_results.shifts_avg = mean(agg_results.shifts);

agg_results.track_estimate_errors_avg = ...
mean(abs(agg_results.track_estimate_errors));

agg_results.trackestimate_naiveerrorsavg = ...
mean(abs(agg_results.trackestimate_naiveerrors));

agg_results.trackestimate_noveltyerrorsavg = ...
    mean(abs(agg_results.trackestimate_noveltyerrors));

if f_scores
    
    disp('calculating f-scores');

    [ F1 ] = results_fscore( agg_results, 0 );
    [ F2 ] = results_fscore( agg_results, 1 );
    [ F3 ] = results_fscore( agg_results, 2 );

    if ~isempty(results(1).predictions_tracksnotknown)
        [ F4 ] = results_fscore( agg_results, 3 );
        agg_results.F1Score_OursEstimated = F4;
    end

    % fscores
    agg_results.F1Score_Ours = F1;
    agg_results.F1Score_Novelty = F2;
    agg_results.F1Score_Guesses = F3;
end

end
