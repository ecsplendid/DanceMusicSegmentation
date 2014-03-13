function [ S ] = getcost_symmetry( C, W, min_trackwidth )
%%

[T ~] = size(C);

% find symmetry matrix
S = inf( T, W );

tic
for w = min_trackwidth:W 

	for t=1:T-(w+1)
        
        U = nan( min(T-t*2,w-1), 1 );
        
        for i=1:min(T-(t+w),w-1)
            
            v = diag( C, i );
            v = v( t:(t+i-1) );
            U( i ) = v'*fliplr(v);
       
        end
        
         S( t, w ) = sum(U);
   
    end
end
toc

%S(:,1:w )=inf;

%ms = max( S( ~isinf( S ) ) );
%S = S./ms;

%%
end