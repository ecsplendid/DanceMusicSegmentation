function [SC] = getcost_contigstatic(...
    show, config, future ) 
 %getcost_contigstatic uses a copy of the dynamic programming
 %implementation used in getcost_sum3. What this does is almost identical 
 %other than that it only considers contigous tiles that are <0 or >0
 %the intuative explanation for this cost matrix is that it only considers
 %contigous self similar regions that do not evolve with time i.e. it
 %captures how much the track stays the same/static and how far into the
 %future/past
 %runs in O(2T(1/2(W^2)))
 % future=1 use future self similarity, 0 means use past self similarity

%%

C = show.CosineMatrix;
T = show.T;
W = show.W;
window_size = config.contig_windowsize;

if(future == 1)
    costcontig_incentivebalance = config.costcontigfuture_incentivebalance;
else
    costcontig_incentivebalance = config.costcontigpast_incentivebalance;
end

SS = getmatrix_selfsim( C, W, future );
CF = ones( T, W-window_size-1 );

% transform the self similarity matrix with the contiguity information
for t = 1:T
    
    limit = t;
    
    if(future)
        limit = T-t;
    end
    
    for x=(window_size):min(W-window_size-1, limit)
        
        vals = SS( t, (x-window_size+1):x );
        
        sgns = sign( vals );
        
        
        same_sign = all( sgns==sgns(1) );
        
        if( ~same_sign )
           
            score = 0;
            
        elseif ( sign( vals(end) ) == -1)

            score =  vals(end) / window_size;
           %score =  mean(vals);
           %score = mean(vals);
           
            score = score * (1-costcontig_incentivebalance);
        else
           score =  vals(end) / window_size;
           % score =  mean(vals);
            %score = mean(vals);
            
            score = score * (costcontig_incentivebalance);
        end
        
        CF( t, x ) = score;
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
        
        SC( t_ind, w ) = score/w;
    end
end

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(isinf(SC)) = max(max((~isinf(SC))));

SC(:,1:show.w-1 )=inf;


end