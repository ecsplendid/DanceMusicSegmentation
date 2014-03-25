function [SC] = getcost_contigfast(...
    C, W, min_w, ...
    costcontig_incentivebalance ) 
 %getcost_contigfast dynamic programming implementation of getcontig fast

%%
T = size( C, 1 );
SC = inf( T, W );

SF = getmatrix_selfsim( C, W, 1 );
SP = getmatrix_selfsim( C, W, 0 );


%S = S + getmatrix_selfsim( C, W, 1 );

%S = cumsum(S')';

%S = normalize_costmatrix(S);

%SF = SF .* repmat( gausswin(W,2)', T, 1 );
%SF = SF ./ repmat( (1:W), T, 1 );

%imagesc(SF)

%%

% first place a track of size w then slide it
for width=2:W

    % place a small manual triangle of size w
    % for each dag, there are width dags
    % take progression 1 to mean we skip the main diag

  %  TR = C_DAG( 2:width, 2:width );
   % TR = triu( fliplr(TR) );
  %  initial_cost = sum( TR((1:(width-1)^2) ));
  
   % SC( 1, width ) = initial_cost;
    
    % now shift this triangle along to T-w+1
    for t=1:(T-(width))+1
        
   
        new_score = 0;
        
       % for d=1:width
          %  d_score = 0;
         %   d_score = d_score - C_DAG( d, t+(d) ) ;
          %  d_score = d_score + C_DAG( d, t );
         %   new_score = d_score;
       % end
        
        
        TF = SF( t:(t+width-1), 1:width );
        TF = triu( flipud( TF )' );
        
        blue = sum(sum(abs(TF(TF<0))));
        red = sum(sum(abs(TF(TF>=0))));
        
        blue=blue*2;
        red=red*2;
        
        blue = blue .* (costcontig_incentivebalance);
        red = red .* (1-costcontig_incentivebalance);
        
        blue = blue / width;
        red = red / width ;
        
        blue = 1-blue;
        
        score = (blue)+red;
        
        SC(t, width) = score;
        
        %%
        
        
    end
end



SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;

end