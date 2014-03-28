function [SC] = getcost_contigstatic(...
    C, W, min_w, ...
    costcontig_incentivebalance, window_size, future ) 
 %getcost_contigstatic uses a copy of the dynamic programming
 %implementation used in getcost_sum3. What this does is almost identical 
 %other than that it only considers contigous tiles that are <0 or >0
 %the intuative explanation for this cost matrix is that it only considers
 %contigous self similar regions that do not evolve with time i.e. it
 %captures how much the track stays the same/static and how far into the
 %future/past
 %runs in O(TW)
 % future=1 use future self similarity, 0 means use past self similarity

%%

T = size( C, 1 );

SS = getmatrix_selfsim( C, W, future );
CF = inf( T, W-window_size-1 );

% transform the self similarity matrix with the contiguity information
for t = 1:T
    
    limit = t;
    
    if(future)
        limit = T-t;
    end
    
    for x=(window_size):min(W-window_size-1, limit)
        
        vals = SS( t, (x-window_size+1):x );
        
        same_sign = range( sign( vals ) ) == 0;
        
        what_sign = sign( vals(1) );
        
        score = mean(vals);
        
        if( ~same_sign )
            score = 0;
        elseif (what_sign == -1)
            score = score * (1-costcontig_incentivebalance);
        else
            score = score * (costcontig_incentivebalance);
        end
        
        CF( t, x ) = score/x;
    end
end


%%
SC = inf( T, W );

% generate SC using the dynamic program from getcost_sum3
for t=1:T
    
    score = 0;
    
     limit = T-t;
     t_ind = t;
     
     if(future)
         limit = t;
     end

    for w=window_size:min(W-window_size-1, limit)
        
        c_ind = t+(w-1);
       
        if(future)
            c_ind = t-(w-1);
            t_ind = (t-w)+1;
        end 
        
        score = score + sum( CF( c_ind, window_size:w ) );
        
        SC( t_ind, w+window_size+1 ) = score / w;
    end
end


SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

imagesc(SC)

end