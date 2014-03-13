function [ matched_tracks ] = evaluate_performance( indexes, best_begin )

% automatically calculate perf for [70,60,30,10] seconds

thresholds = [60,30,20,10,5,3,1];

matched_tracks = false(length( indexes ), length(thresholds) );

assert( length(best_begin) == length(indexes) );

for p=1:length(best_begin)

    for t=1:length(thresholds)

        for truth = 1:size(indexes,2)
       %     assert (sum(abs( best_begin(p)-indexes(:,truth)) < thresholds(t)) <= 1, 'black split could satisfy >1 white ones');
        end

       for a=1:length(indexes)
           if( any( abs( best_begin(p)-indexes(a,:) ) < thresholds(t) ) && matched_tracks(a,t) == 0 )
               matched_tracks(a,t)=true;
           end
       end
    end
end

end


%%

