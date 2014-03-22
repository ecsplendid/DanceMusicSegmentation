%function [SC] = getcost_contigfast(...
 %   C, W, min_w, ...
 %   costcontig_incentivebalance) 
% getcost_contigfast dynamic programming implementation of getcontig fast

%%
tic;
T = size(C,1);
SC_unnormalized = inf( T, W );
SC = inf( T, W );

% note this skips the first dag
C_dags = getmatrix_indiagonals( C, 1 );

score_changes = nan(T);

% first place a track of size w then slide it
for width=min_w:W

    initial_cost = 0;
    % place a small manual triangle of size w
    % for each dag, there are width dags
    % -1 on width because getmatrix_indiagonals skips first dag
    for progression=1:(width-1)
    
        % for each element pair start (top down, fat diag first)
        % the single element on the top gets ignored
        for time = 2:(width-progression)

            p1 = C_dags(progression, time-1);
            p2 = C_dags(progression, time );
            
            get_contigscore;
            
            initial_cost = initial_cost + new_cost;
                
        end
    end
    
    SC( 1, width ) = initial_cost;
    
    % now shift this triangle along to T-w+1
    for t=2:T-(width+1)
        
        score_change = 0;
        
        from_previoustriangle = C_dags( 1:width-1, t-1 );
        new_points = C_dags( 1:width-1, t );
        
        for progression=1:width-1
            
            p1 = from_previoustriangle(progression);
            p2 = new_points(progression);
            get_contigscore;
            
            score_change = score_change + new_cost;
        end
        
        new_score = score_change;
        
        if( t>2 )
            new_score = new_score - score_changes(t-1);
        end
        
        SC(t, width) = (SC(t-1, width) + new_score );
        
        score_changes( t ) = score_change;
    end
end

toc;

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

imagesc(SC)


%end