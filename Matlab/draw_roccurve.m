function draw_roccurve( results, predictions )
% for every result, for every threshold
% get the true positives and false positives
% subsequent predictions within a used boundary yields a false positive
% draw the point on a roc curve for all thresholds, note that TP,FP /in [0,1]

no_tracks = length( predictions );

padded_size = 40;

limit = 600;

TPRS=nan(limit,1);
FPRS=nan(limit,1);

for tol=1:limit

    TP = 0;
    FP = 0;
    
    used = zeros( 1, padded_size );
    
    for t=1:no_tracks

        i = results.show.indexes(t);

        % are there any preds within tolerance
        m = abs( i - results.show.space( ...
            results.predictions ) ) < tol;

        m =  padarray(m , [0 padded_size-length(m)], 'post');
        
        mallowed = m & ~used;
        
        TP = TP + sum( mallowed );
        FP = FP + sum( used & m );
        
        used = used | m;
    end

    TPRS(tol) = TP/no_tracks;
    FPRS(tol) = FP/no_tracks;
end


for i=1:limit
    plot( FPRS(i), TPRS(i), 'k*' );
    if i==1
        hold on;
    end
end

hold off;

end
