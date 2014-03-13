function [ S ] = find_symmetrycostmatrix( C, W, blank_tiles, T )

% find symmetry matrix
S = inf( T, W );

for w = blank_tiles:W 

	for t=1:T-(w+1)
        
        U = nan( min(T-t*2,w-1), 1 );
        
        for i=1:min(T-(t+w),w-1)
            
            v = diag( C, i );
            v = v( t:(t+i-1) );
            U( i ) = v'*fliplr(v);
       
        end
        
         S( t, w ) = sum(U) * (1/w);
   
    end
end

S(:,1:blank_tiles )=inf;

ms = max( S( ~isinf( S ) ) );
S = S./ms;

end