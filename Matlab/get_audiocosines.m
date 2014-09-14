function [ cosines ] = get_audiocosines( ...
    feature_tiles, method )
%get_audiocosines for a matrix of feature vectors return the cosine matrix

if nargsin < 1
    method = 1;
end

if method == 1
    
    % the built in matlab matrix multiplication is incredibly fast
    cosines = feature_tiles * feature_tiles';
    
elseif method == 2
    
    for x=1:T
        inds = x:min(x+W,T);
        
        C(x,inds) = abs( ...
            dot( ...
            repmat( fd(:, x), 1, length(inds) ), ...
            fd(:, inds) ) ...
            );
        
    end
else
    
end

end

