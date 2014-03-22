function [SC] = getcost_contigfast(...
    C, W, min_w, ...
    costcontig_incentivebalance) 
 %getcost_contigfast dynamic programming implementation of getcontig fast

%%

T = size(C,1);
SC = inf( T, W );

% note this skips the first dag
C_dags = getmatrix_indiagonals( C, 1 );

score_changes = nan(T);

% first place a track of size w then slide it
for width=min_w:W

    initial_cost = 0;
    % place a small manual triangle of size w
    % for each dag, there are width dags
    % width from 2 because getmatrix_indiagonals skips first dag
    % i.e. the first row is NaNs
    for progression=2:(width)
    
        normalization_parameter = width / progression;
        
        % for each element pair start (top down, fat diag first)
        % the single element on the top gets ignored
        for time = 2:(width-progression)

            p1 = C_dags(progression, time-1);
            p2 = C_dags(progression, time );
            
            new_cost = 0;
            if( max(p1, p2) < 0)
            new_cost = (abs(p1)+abs(p2))/2;
            % contiguity more important in the center 
            % of the expected track size
            % contiguity more important the further away it is
            new_cost = new_cost / normalization_parameter;
            new_cost = new_cost * -costcontig_incentivebalance;

            elseif( min(p1,p2) > 0 )
            new_cost = (abs(p1)+abs(p2))/2;
            % contiguity more important in the center 
            % of the expected track size
            % contiguity more important the further away it is
            new_cost = new_cost / normalization_parameter;
            new_cost = new_cost * (1-costcontig_incentivebalance);
            end

            
            initial_cost = initial_cost + new_cost;
                
        end
    end
    
    SC( 1, width ) = initial_cost;
    
    % now shift this triangle along to T-w+1
    for t=2:T-(width+1)
        
        score_change = 0;
        
        % we start from 2 because we don't consider the first diag
        % we don't consider the single point case at all
        from_previoustriangle = C_dags( 2:width-1, t-1 );
        new_points = C_dags( 2:width-1, t );
        
        for progression=2:width-1
            
            normalization_parameter = (progression/ width);
            
            p1 = from_previoustriangle(progression-1);
            p2 = new_points(progression-1);
            
           
            if( max(p1, p2) < 0)
            new_cost = (abs(p1)+abs(p2))/2;
            % contiguity more important in the center 
            % of the expected track size
            % contiguity more important the further away it is
            new_cost = new_cost / normalization_parameter;
            new_cost = new_cost * -costcontig_incentivebalance;
            score_change = score_change + new_cost;
            elseif( min(p1,p2) > 0 )
            new_cost = (abs(p1)+abs(p2))/2;
            % contiguity more important in the center 
            % of the expected track size
            % contiguity more important the further away it is
            new_cost = new_cost / normalization_parameter;
            new_cost = new_cost * (1-costcontig_incentivebalance);
            score_change = score_change + new_cost;
            end
            
        end
        
        new_score = score_change;
        
        if( t>2 )
            new_score = new_score - score_changes(t-1);
        end
        
        SC(t, width) = (SC(t-1, width) + new_score );
        
        score_changes( t ) = score_change;
    end
end

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

end