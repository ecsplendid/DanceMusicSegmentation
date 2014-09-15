function [ agg_results ] = ...
    run_experiments( config )
%run_experiments run the experiments for the dataset requested in the
%configuration and return the results in an object
tic;

if( nargin == 0 )
    config = config_getdefault;
end

shows = get_allshows(config);

experiment_results = cell(length(shows),1);

parfor s=1:length(shows)
    experiment_results{s} = execute_show( s, config );
end
    
agg_results = get_aggregateresults(experiment_results, config);

agg_results.execution_time = toc;

end


