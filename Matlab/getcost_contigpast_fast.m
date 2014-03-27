function [SC] = getcost_contigpast_fast(...
    C, W, min_w, ...
    costcontig_incentivebalance, window_size ) 
 %getcost_contigfast dynamic programming implementation of getcontig fast

%%
T = size( C, 1 );
SC = inf( T, W );

SF = getmatrix_selfsim( C, W, 0 );

CP = nan( T, W-1 );


for t=1:T
    for x=(window_size):min(W, t)
        
        vals = SF( t, (x-window_size+1):x );
        
        same_sign = range( sign( vals ) ) == 0;
        
        score = mean(vals);
        
        if( ~same_sign )
            score = 0;
        end
        
        CP( t, x-1 ) = score/x;
    end
end


%%

% first place a track of size w then slide it
for width=2:W

    % now shift this triangle along to T-w+1
    for t=1:(T-(width))+1
        
        new_score = 0;
        
        TP = CP( t:(t+width-1), 1:width-window_size );
        TP = tril(TP);
        
        blue = sum(sum(abs(TP(TP<0))));
        red = sum(sum(abs(TP(TP>=0))));
        
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