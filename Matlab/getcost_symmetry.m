function [ SC ] = getcost_symmetry( C, W, min_w, ...
    costsymmetry_incentivebalance )
%%
T = size(C,1);

SC = inf( T, W );
gwin = gausswin( W );

% dont tweak again
high_thresh = 0.1;
low_thresh = -0.4515;

for w=min_w:W
    for t=1:T-w+1

        %%
      
        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_dags = getmatrix_indiagonals(C_square, 1);
        
       % figure(10)
       % imagesc(C_square)
       % colorbar;
        
        score = 0;
       
        % for every dag (no point looking at first one though)
        for i=2:size( C_dags, 1 )
            
            d1 = C_dags( i, 1:size( C_dags, 1 )-i+1 );
            d2 = fliplr( d1 );
            
            % compare every symmetric pair
            for p=1:size( C_dags, 1 )-i
              
                if( d1(p) < low_thresh && d2(p) < low_thresh )
                   
                    mi = abs(min(d1(p),d2(p)));
                    new_incentive = ((1-mi) / p) * costsymmetry_incentivebalance;
                    new_incentive = new_incentive * gwin(w);
                    
                    score = score - new_incentive;
                end 
            
                if( p > min_w && d1(p) > (high_thresh) && d2(p) > (high_thresh) )
                   
                    ma = abs(max(d1(p),d2(p)));
                    disincentive = (ma) /w;
                    disincentive = disincentive * (1-costsymmetry_incentivebalance);
                    
                    score = score + disincentive;
                    
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


SC = normalize_costmatrix(SC);



SC(:,1:min_w )=inf;


%%

end