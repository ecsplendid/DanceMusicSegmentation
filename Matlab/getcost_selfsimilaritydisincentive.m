function [SD] = getcost_selfsimilaritydisincentive(T,W,S) 

    SD = zeros( T, W );

    for t=1:T
        for w=1:min(W,T-t)

            SD( t, w ) = sum( 1-S(t, 1:w) ) ;

        end
    end

    SD = SD./ max(max(SD));
    
end