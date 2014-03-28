%function [SC] = getcost_symmetry3 (...
%    C, W, min_w, ...
%    incentivebalance ) 
 % getcost_symmetry3 dynamic programming implementation of getcost_symmetry2
 
%%
T = size( C, 1 );
%SC = inf( T, W );

%SF = getmatrix_selfsim( C, W, 1 );
%SP = getmatrix_selfsim( C, W, 0 );


SC = inf( T, W );

for t = 1:T-W

    score = 0;

    widths = 1:1:W;
    l = length(widths);
    
    % assuming W is an odd number
    for w = 1:l

        ct = ((l-w)+1)+(t-1);
        limit = min( (ct)+(w-1)*2, T );
        
        future = C( ct, (ct):limit);
        past = C( ct:limit, ct)';

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
       
        SC( ct, widths(w) ) = score / w;
 
    end
end

imagesc(SC)


%end