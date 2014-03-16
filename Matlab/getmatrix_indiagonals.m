function [ D ] = getmatrix_indiagonals( M, return_matrix )
% getmatrix_indiagonals 
% assumes a symetric matrix, will return a vector (S*(S+1))/2 of concatenated
% diagonals, if m==1 then we return a matrix with a diagonal on each row
%%

[S, ~] = size(M);

if( nargin > 1 && return_matrix == 1 )
    D = nan( S, S );
else
    D = nan( (S*(S+1))/2, 1 );
    return_matrix = 0;
end

last_index = 1;

for i=1:S

        if( return_matrix)
            D( i, 1:(S-i+1) ) = diag( M, i-1 );
        else
            D( last_index:(last_index+S-i) ) = diag( M, i-1 );
        end
    
       last_index = (last_index+S-i)+1;
end


end

