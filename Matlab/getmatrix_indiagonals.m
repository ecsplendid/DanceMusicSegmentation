function [ D ] = getmatrix_indiagonals( M, return_matrix, num_dags )
% getmatrix_indiagonals 
% assumes a symetric matrix, will return a vector (S*(S+1))/2 of concatenated
% diagonals, if m==1 then we return a matrix with a diagonal on each row
% DOESNT RETURN THE FIRST DIAGONAL
%%

[S, ~] = size(M);

if( nargin > 1 && return_matrix == 1 )
    D = zeros( S, S );
else
    D = zeros( ((S-1)*(S))/2, 1 );
    return_matrix = 0;
end

%%

last_index = 1;

for i=1:num_dags

    if( return_matrix)
        
        dg = diag( M, i-1 );
        
        D( i, 1:(length(dg)) ) = dg;
    else
        D( last_index:(last_index+S-i) ) = diag( M, -(i-1) );
    end

   last_index = (last_index+S-i)+1;
end


end

