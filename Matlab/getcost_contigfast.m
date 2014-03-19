%function [SC] = getcost_contigfast(...
%    C, W, min_w, ...
 %   costcontig_incentivebalance) 
%%
T = size(C,1);
SC = inf( T, W );

gwin_large = gausswin(W);

C_dags = getmatrix_indiagonals(C,1);


% precompute the first triangle SC(W,1)

score = 0;

score_cache = zeros(T,W);

for w=2:W
   for i=2:W-w
      p1=C_dags( w, i-1 );
      p2=C_dags( w, i );
      
      mix = mean([p1 p2]);
      
      if( p1 < 0 && p2 < 0 )
          score = score - mix;
      end

      if( p1 > 0 && p2 > 0 )
          score = score + mix;
      end
   end
   
   if( w==2 )
       score_cache( 1, w ) = score;
   end
end


SC( 1, W ) = score;

% now slide along to T-W+1 and do the dynamic program part

for t=2:T-W+1
   
    new_score = 0;
    
    for i=2:W
       
        p1=C_dags( W-i+1, t );
        p2=C_dags( W-i+2, t );

        if( p1 < 0 && p2 < 0 )
            new_score = new_score - mix;
        end

        if( p1 > 0 && p2 > 0 )
            new_score = new_score + mix;
        end  
    end
    
    score_cache( t, W ) = new_score;
    
    SC( t, W ) = SC( t-1, W ) + new_score - score_cache( t-1, W );
    
    
    
end

imagesc(SC)




%end