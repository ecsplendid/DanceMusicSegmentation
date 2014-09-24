function [F, Rr, Pf] = results_fscore( ag_results, mode, how_many )
% for every result, for every threshold
% get the true positives and false positives
% subsequent predictions within a used boundary yields a false positive
% draw the point on a roc curve for all thresholds, note that TP,FP /in [0,1]
% mode 0: our predictions
% mode 1: novelty function
% mode 2: guesses
% mode 3: ours, track estimated
% this currently runs slow as hell, needs optimization

if nargin < 2
   mode = 0; 
end

limit = 120;

if nargin < 3
    how_many = length( ag_results.results );
end

R=zeros(how_many,limit);
P=zeros(how_many,limit);

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
        assert( ...
            ~isempty(results.predictions_tracksnotknown), ...
'there are no track estimation predictions, include the relevant config file as an argument' )
        predictions = results.predictions_tracksnotknown.predictions;
    end
    
    no_predictions = length( predictions );
    
    no_tracks = length(show.indexes);

    % never more than 50 tracks (some of lindmiks are big)
    padded_size = 50;

    for tol=1:1:limit

        TP = 0;
        FP = 0;

        used = zeros( 1, padded_size );

        for p = 1:no_predictions

            pred = predictions(p);

            diffs = abs( pred - ...
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
            
            [~, in] = min( diffs );
            
            used(in) = used(in) | m(in);
        end
        

        R(s, tol) = TP/no_tracks;
        P(s, tol) = TP/no_predictions;
    end
end

Rr = mean(R);
Pf = mean(P);

F = ((Rr.*Pf)./(Rr+Pf)).*2;

end
