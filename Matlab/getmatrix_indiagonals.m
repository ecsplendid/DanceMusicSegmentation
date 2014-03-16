function [ D ] = getmatrix_indiagonals( M )
% getmatrix_indiagonals 
% assumes a symetric matrix, will return a vector (S*(S+1))/2 of concatenated
% diagonals 
%%

[S, ~] = size(M);

D = nan( (S*(S+1))/2, 1 );

last_index = 1;

for i=1:S

       D( last_index:(last_index+S-i) ) = diag( M, i-1 );

       last_index = (last_index+S-i)+1;
end


end

