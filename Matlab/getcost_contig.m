function [SC] = getcost_contig(C, W, min_w) 
%%
T = size(C,1);

SC = nan( T, W );

% matrix of diagonals 
D = nan( W, T );
assert(size(C,1)==size(C,2));
  
 for i=1:W
    D( i, 1:T-(i-1) ) = diag( C, i-1 ); 
 end
 
D = (D)';
 
for t=1:T
   for w=2:W
      
        dg = D( t, 1:w );
       
        cs = cumsum( dg );
        
        SC( t,w ) =  sum( cs( cs<(0.3*w) ) );
        
   end
end

SC = normalize_costmatrix( SC );

SC = SC .* 10000000;

SC = SC .^ 0.95;

%SC = 1-SC;



% D = cumsum( 1-D )';

% SC = D;
% SC(SC<0)=0;


%SC = [ nan(T,1) SC ];

SC(:,1:min_w )=inf;



%%
end