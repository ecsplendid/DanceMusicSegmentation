function [SC] = getcost_sumfast2(...
    C, W, min_w, ...
    costcontig_incentivebalance ) 
 %getcost_contigfast dynamic programming implementation of getcontig fast

%%
T = size( C, 1 );
SC = inf( T, W );

SF = getmatrix_selfsim( C, W, 1 );
SP = getmatrix_selfsim( C, W, 0 );

SF = SF ./ repmat( (1:W), T, 1 );

imagesc(SF);

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
        
        blue = blue * 2;
        red = red * 2;
        
        blue = blue .* (costcontig_incentivebalance);
        red = red .* (1-costcontig_incentivebalance);
        
        blue = blue / width;
        red = red / width;
        
        blue = 1-blue;
        
        score = (blue)+red;
        
        SC(t, width) = score;
        
        %%
    end
end


SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

end