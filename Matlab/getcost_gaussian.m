function [ SC ] = getcost_gaussian( show, config )
%%

    % get a gaussian window
    gwin = gausswin( show.W, ...
        config.use_costgaussianwidth );
    gwin = -gwin;

    SC = repmat( ( gwin )',...
            show.T, 1  );
        
    SC = normalize_byincentivebias( SC, ...
        config.costgauss_incentivebalance );

SC(:,1:show.w-1 )=inf;
        
end

