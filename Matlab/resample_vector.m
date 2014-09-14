function [ resampled ] = resample_vector( M, outsize )
% Will take a matrix* and subsample it

    resampled = M( repmat( ...
        floor( linspace( 1, size(M,2), outsize ) ), ...
        size(M, 1 ), 1  ) );
end 

