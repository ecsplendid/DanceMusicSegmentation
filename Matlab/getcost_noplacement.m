function [SD] = getcost_noplacement(T,W,S) 

    noplace_map = inf( T,W );
    for t=1:T
        noplace_map(t, (blank_tiles+1):min(W,T-t+1) ) = C( t, (t+blank_tiles):min(t+W-1,T) );
    end

    noplace_map(isinf(noplace_map)) = 0;
    
    map_dissimilar = noplace_map >= noplace_thresh;
    map_others = not( map_dissimilar );
    
    noplace_map( map_others ) = 0;
    noplace_map( map_dissimilar ) = 1;
    
end