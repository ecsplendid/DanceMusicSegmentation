function [ SC ] = getcost_gaussian( show, config )
%%
T = show.T;
W = show.W;

if config.use_costgaussian == 0 
   SC = zeros( T, W ); 
   return;
end

    % get a gaussian window
    gwin = gausswin( show.W, ...
        config.use_costgaussianwidth );
    gwin = -gwin;

    SC = repmat( ( gwin )',...
            show.T, 1  );
        
    SC = normalize_byincentivebias( SC, ...
        config.costgauss_incentivebalance );

SC(:,1:show.w-1 )=inf;

SC = SC .* config.use_costgaussian;
        
end

