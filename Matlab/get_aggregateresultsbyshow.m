function [ ag ] = get_aggregateresultsbyshow( agg_results, show )
%get_aggregateresultsbyshow rerun the get_aggregateresults with a filter on
%the show class, 

    ag = get_aggregateresults( ...
            agg_results.description, ...
            agg_results.results, ...
            agg_results.config, ...
            show );
end