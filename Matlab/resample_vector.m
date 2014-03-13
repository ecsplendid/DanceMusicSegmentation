function [ resampled ] = resample_vector( vector, outsize )
% Will take a vector in and resample it to a certain length using interp

ls = floor( linspace( 1, length(vector), outsize ) );
resampled = nan( outsize,1 );

for i = 1:outsize
    resampled(i) = vector(ls(i));
end


end

