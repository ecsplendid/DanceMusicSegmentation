function [SC] = getcost_symmetrydiff(...
    C, W, min_w, ...
    incentivebalance ) 
 %implementation of the symmetry addition concept

%%

T = size( C, 1 );
SC = inf( T, W );

% evens
for t = 1:T

    odd_score = 0;

    ws = 1:2:min(W, T-t+1 );
    l = length(ws);
    
    for w = 1:l

        wi = ws(w);
        
        ct = t+(l-w);
        
        ahead = min( (ct)+(wi-1), T );

        future = C( ct, (ct):ahead);
        past = C( ahead:-1:(ct), ahead)';

        sym = (past + future)/2;

        new_score = sum(diff(sym)); 
        
        if(new_score<0)
           new_score = new_score * (1-incentivebalance);
        else
           new_score = new_score * (incentivebalance);
        end
        
        odd_score = odd_score + new_score;
        
        SC( ct, wi ) = odd_score;
 
    end
    
    score = 0;

    ws = 2:2:min(W, T-t+1 );
    l = length(ws);
    
    for w = 1:l

        wi = ws(w);
        
        ct = t+(l-w);
        
        ahead = min( (ct)+(wi-1), T );
        behind = (ct)-(wi-1);
        
        future = C( ct, (ct):ahead);
        past = C( ahead:-1:(ct), ahead)';
        sym = (past + future)/2;

        new_score = sum(diff(sym)); 
        
        if(new_score<0)
           new_score = new_score * (1-incentivebalance);
        else
           new_score = new_score * (incentivebalance);
        end
        
        score = score + new_score ;
        
        SC( ct, wi ) = score;
 
    end
end


% now we have to build up the triangle 1:W iteratively
for i=1:2:W-1

    t=1;

    score = 0;

    ws = 2:2:i;

    l = length(ws);

    % assuming W is an odd number
    for w = 1:l

        wi = ws(w);

        ct = t+(l-w);

        ahead = min( (ct)+(wi-1), T );
        behind = (ct)-(wi-1);

        future = C( ct, (ct):ahead);
        past = C( ahead:-1:(ct), ahead)';

        sym = (past + future)/2;

        new_score = sum(diff(sym)); 
        
        if(new_score<0)
           new_score = new_score * (1-incentivebalance);
        else
           new_score = new_score * (incentivebalance);
        end

        score = score + new_score;

        SC( ct, ws(w) ) = score;

    end

    score = 0;

    ws = 1:2:i;

    l = length(ws);

    % assuming W is an odd number
    for w = 1:l

        wi = ws(w);

        ct = t+(l-w);

        ahead = min( (ct)+(wi-1), T );
        behind = (ct)-(wi-1);

        future = C( ct, (ct):ahead);
        past = C( ahead:-1:(ct), ahead)';

        sym = (past + future)/2;

        new_score = sum(diff(sym)); 
        
        if(new_score<0)
           new_score = new_score * (1-incentivebalance);
        else
           new_score = new_score * (incentivebalance);
        end

        score = score + new_score;

        SC( ct, ws(w) ) = score;

    end
end


SC = normalize_byincentivebias(SC, incentivebalance);

SC(:,1:min_w-1 )=inf;

end