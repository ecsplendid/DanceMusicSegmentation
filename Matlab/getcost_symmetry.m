function [ SC ] = getcost_symmetry( C, W, min_w, ...
    costsymmetry_incentivebalance )
%%
T = size(C,1);

SC = inf( T, W );
gwin = gausswin( W );

C_BIGdags = getmatrix_indiagonals(C, 1);

for w=min_w:W
    for t=1:T-w+1

        %%
      
        % we have the triangle
        C_dags = C_BIGdags(1:w, t:t+w-1);
        
        high_thresh = 0;
        low_thresh = 0;
        
       % figure(10)
       % imagesc(C_square)
       % colorbar;
        
        score = 0;
       
        % for every dag (no point looking at first one though)
        for i=2:size( C_dags, 1 )
            
            line = C_dags( i, 1:size( C_dags, 1 )-i+1 );
           
            sz = size( C_dags, 1 );
            
            % compare every symmetric pair
            for p=1:sz-i
              
                p1 = line(p);
                p2 = line( sz-i-p+1 );
                
                mix = (abs(p1) + abs(p2))/2;
                
                if( p1 < low_thresh && p2 < low_thresh )
                   
                    new_incentive = (mix / w);
                    new_incentive = new_incentive * costsymmetry_incentivebalance;
                    
                    score = score - new_incentive;
                end 
            
                if( p > min_w && p1 > (high_thresh) && p2 > (high_thresh) )
                   
                    new_disincentive = (mix / w);
               
                    new_disincentive = new_disincentive * (1-costsymmetry_incentivebalance);
                    
                    score = score + new_disincentive;
                    
                end 
            end
        end
        
        
        %%
        
        SC(t, w) = score;
    end
    
   %imagesc(SC);
   % colorbar;
   % drawnow;
end


SC = normalize_byincentivebias(SC, costsymmetry_incentivebalance);



SC(:,1:min_w )=inf;


%%

end