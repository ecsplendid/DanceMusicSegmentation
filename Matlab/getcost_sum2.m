function [SC] = getcost_sum2( C, W, min_w, costcontig_incentivebalance ) 
% getcost_sum2 this produces the same result as getcost_sum but uses a
% different strategy to achieve the result, it takes a future self
% similarity matrix from getmatrix_selfsim( C, W, 1 ) and then fits
% triangles representing tracks of all sizes (1:W) down 1:T
% it's slow but should be clear to understand, runs in O(TW^2)
% we are going in this direction because it makes it easier to implement
% the contiguity cost matrices in this fashion
 
%%
T = size( C, 1 );
SC = inf( T, W );

SF = getmatrix_selfsim( C, W, 1 );

%%

% first place a track of size w then slide it
for width=2:W

    % now shift this triangle along to T-w+1
    for t=1:(T-(width))+1
        
        new_score = 0;
        
        TF = SF( t:(t+width-1), 1:width );
        TF = triu( flipud( TF )' );
        
        blue = sum(sum(abs(TF(TF<0))));
        red = sum(sum(abs(TF(TF>=0))));
        
        blue = blue ;
        red = red ;
        
        blue = blue .* (costcontig_incentivebalance);
        red = red .* (1-costcontig_incentivebalance);
        
        blue = blue / width;
        red = red / width;
        
        blue = -blue;
        
        score = (blue)+red;
        
        SC(t, width) = score;
        
        %%
    end
end


SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

end