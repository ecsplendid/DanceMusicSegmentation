function [SD] = getcost_contig(T,W,S) 

    contig_map = zeros( T, W );
    
    for t=1:T
       
        contig_map( t,: ) = conv( selfsim_map_close( t,: ), gausswin(5) , 'same' );
        
        cs = zeros( 1,W );
        last_high = 0;
        for i=2:W %% do the cum sum thing
            if contig_map( t,i ) == 0
                cs(i) = 0;
                last_high = max(cs);
            else
                cs(i) = min(inf, cs(i-1)+contig_map(t,i) );
            end
        end
        
        contig_map( t,: ) = cs;
       
        contig_map( t,: ) = contig_map( t,: ) .* gausswin(W,contiguity_gaussscale)';
    end
    
end