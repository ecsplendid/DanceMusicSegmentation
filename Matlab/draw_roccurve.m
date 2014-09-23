function [tpf, fpf] = draw_roccurve( ag_results, mode, how_many )
% for every result, for every threshold
% get the true positives and false positives
% subsequent predictions within a used boundary yields a false positive
% draw the point on a roc curve for all thresholds, note that TP,FP /in [0,1]
% mode 0: our predictions
% mode 1: novelty function
% mode 2: guesses

if nargin < 2
   mode = 0; 
end

limit = 600;

if nargin < 3
    how_many = length( ag_results.results );
end

TPRS=zeros(how_many,limit);
FPRS=zeros(how_many,limit);

for s=1:how_many

    results = ag_results.results(s);
    show = results.show;
    
    if mode==0 % our predictions
        predictions = results.predictions;
    elseif mode==1 % novelty
        predictions = results.trackestimate_novelty;
    elseif mode==2 % guesses
        predictions = ...
            floor(linspace( ...
                1, ...
                length(results.show.space), ...
                length( show.indexes ) + 2 ));
            
            predictions = predictions(2:end-1);
    elseif mode==3 % our predictions (track estimated)
        predictions = results.predictions_tracksnotknown.predictions;
    end
    
    no_predictions = length( predictions );
    
    no_tracks = length(show.indexes);

    % never more than 28 tracks
    padded_size = 28;

    for tol=1:1:limit

        TP = 0;
        FP = 0;

        used = zeros( 1, padded_size );

        for p=1:no_predictions

            pred = predictions(p);

            diffs = abs( results.show.space( pred ) - ...
                 results.show.indexes  )';
            
            % are there any preds within tolerance
            m = diffs < tol;

            m =  padarray(m , [0 padded_size-length(m)], 'post');

            if sum(m) == 0 || sum( used & m ) > 0
                FP = FP + 1;
            end
            
            if sum( m & ~used ) > 0
                TP = TP + 1;
            end
            
            [mn, in] = min( diffs );
            
            used(in) = used(in) | m(in);
        end
        

        TPRS(s, tol) = TP/no_tracks;
        FPRS(s, tol) = FP/no_predictions;
    end
end

tpf = mean(TPRS);
fpf = mean(FPRS);

end
