%function [ S ] = getcost_symmetry( C, W, min_trackwidth )
%%

[T ~] = size(C);

% matrix of diagonals 
D = nan( W, T );

for i=1:W
   D( i, 1:T-(i-1) ) = diag( C, i-1 ); 
end

% find symmetry matrix
S = inf( T, W );

tic
for w = min_trackwidth:W 

	for t=1:((T-(w+1))-1)
        
        U = zeros( 1, min( W, T-t ) );
        
        for i=1:min( W, T-t )
            
            DS = D( w, t:min( (t+w), (T-w+1) ) );
            
            U( i ) = (DS*fliplr(DS'))/w;
       
        end
        
        if( sum(isnan(U))>0 )
           a=1; 
        end
        
         S( t, w ) = sum(U);
   
    end
end
toc

S( S==0 ) = inf;

ms = max( S( ~isinf( S ) ) );
S = S./ms;

SUMC=S;

%%
%end