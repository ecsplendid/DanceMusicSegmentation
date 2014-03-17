function [ SC ] = getcost_gaussian( T, W, min_w, ...
    use_costgaussian, use_costgaussianwidth )
%%

    % get a gaussian window
    gwin = 1-gausswin( W, use_costgaussianwidth );
    gwin = gwin.*use_costgaussian;
    gwin = -gwin;

    SC = repmat( ( gwin )',...
            T, 1  );

    SC(:,1:min_w) = inf;
        
end

