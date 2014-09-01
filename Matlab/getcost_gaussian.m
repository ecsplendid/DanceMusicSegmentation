function [ SC ] = getcost_gaussian( T, W, min_w, ...
     use_costgaussianwidth, costgauss_incentivebalance )
%%

    % get a gaussian window
    gwin = gausswin( W, use_costgaussianwidth );
    gwin = -gwin;

    SC = repmat( ( gwin )',...
            T, 1  );
        
    SC = normalize_byincentivebias( SC, costgauss_incentivebalance );

    SC(:,1:min_w-1) = inf;
        
end

