function [S] = getcost_selfsimilarity(T,W,C) 

    S = inf( T,W );
    
    for t=1:T
        S(t, 1:min(W,T-t+1) ) = C( t, t:min(t+W-1,T) );
    end

end