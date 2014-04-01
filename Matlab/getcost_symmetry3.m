function [SC] = getcost_symmetry3 (...
    C, W, min_w, ...
    incentivebalance ) 
 % getcost_symmetry3 dynamic programming implementation of getcost_symmetry
 
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

        diff_sign = sign(past) ~= sign(future);
        neg_sign = sign(past)==-1 | sign(future)==-1;
        pos_sign = ~neg_sign;

        sym = (past .* future);

        sym( diff_sign ) = 0;

        sym( neg_sign ) = -sym( neg_sign );

        sym( neg_sign ) = sym( neg_sign ) .* (1-incentivebalance);
        sym( pos_sign ) = sym( pos_sign ) .* (incentivebalance);
        
        new_score = sum(sym); 
        
        odd_score = odd_score + new_score ;
        
        SC( ct, wi ) = odd_score / wi;
 
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

        diff_sign = sign(past) ~= sign(future);
        neg_sign = sign(past)==-1 | sign(future)==-1;
        pos_sign = ~neg_sign;

        sym = (past .* future);

        sym( diff_sign ) = 0;

        sym( neg_sign ) = -sym( neg_sign );

        sym( neg_sign ) = sym( neg_sign ) .* (1-incentivebalance);
        sym( pos_sign ) = sym( pos_sign ) .* (incentivebalance);
        
        new_score = sum(sym); 
        
        score = score + new_score ;
        
        SC( ct, wi ) = score / wi;
 
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

        diff_sign = sign(past) ~= sign(future);
        neg_sign = sign(past)==-1 | sign(future)==-1;
        pos_sign = ~neg_sign;

        sym = (past .* future);

        sym( diff_sign ) = 0;

        sym( neg_sign ) = -sym( neg_sign );

        sym( neg_sign ) = sym( neg_sign ) .* (1-incentivebalance);
        sym( pos_sign ) = sym( pos_sign ) .* (incentivebalance);

        new_score = sum(sym); 

        score = score + new_score;

        SC( ct, ws(w) ) = score / wi;

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

        diff_sign = sign(past) ~= sign(future);
        neg_sign = sign(past)==-1 | sign(future)==-1;
        pos_sign = ~neg_sign;

        sym = (past .* future);

        sym( diff_sign ) = 0;

        sym( neg_sign ) = -sym( neg_sign );

        sym( neg_sign ) = sym( neg_sign ) .* (1-incentivebalance);
        sym( pos_sign ) = sym( pos_sign ) .* (incentivebalance);

        new_score = sum(sym) ; 

        score = score + new_score;

        SC( ct, ws(w) ) = score / wi;

    end
end

SC = normalize_byincentivebias(SC, incentivebalance);
SC(:,1:min_w-1 )=inf;

end