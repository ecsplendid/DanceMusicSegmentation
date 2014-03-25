function [ S ] = getmatrix_selfsim( C, W, future )
% getmatrix_selfsim 
% will return the self similarity for each t in C going forward W steps
% future == 1 will give future self similarity, 0 past self similarity
%%

[T, ~] = size(C);
S = nan( T, W );

if(future)
    for t=1:T

        width = min( W, T-t+1 );
        S( t, 1:width ) = C( t, t:t+width-1 );

    end
else
    for t=1:T
        
        limit = min(W, t);
        
        S( t, 1:limit ) =  C( t:-1:(t-(limit-1)), t );
        
    end
end


end

