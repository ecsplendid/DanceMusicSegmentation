function [SC] = getcost_contigstatic2(...
    C, W, min_w, ...
    costcontig_incentivebalance, window_size, future ) 
 %getcost_contigstatic uses a copy of the dynamic programming
 %implementation used in getcost_sum3. What this does is almost identical 
 %other than that it only considers contigous tiles that are <0 or >0
 %the intuative explanation for this cost matrix is that it only considers
 %contigous self similar regions that do not evolve with time i.e. it
 %captures how much the track stays the same/static and how far into the
 %future/past
 %runs in O(2T(1/2(W^2)))
 % future=1 use future self similarity, 0 means use past self similarity

 %%% trs,310814, use getcost_contigstatic for now, this one is out of date
 
%%

T = size( C, 1 );

SS = getmatrix_selfsim( C, W, future );

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
        
        same_sign = range( sign( SS( t_ind, (w-window_size+1):w ) ) ) == 0;
        
        score = score + sum( SS( c_ind, window_size:w ) );
      
        if( same_sign )
            score = score + sum( ( SS( t_ind, (w-window_size+2):w ) ) );
        end
        
        SC( t_ind, w+window_size+1 ) = score / w;
    end
end


SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;


end