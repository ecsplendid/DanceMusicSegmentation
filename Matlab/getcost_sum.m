function [ SC ] = getcost_sum( show, config )
%   getcost_sum 
%   builds the sum cost matrix calling the dynamic program get_summationfast
%   which is described in detail in the first paper. Runs in O(2TW)

W = show.W;
T = show.T;
C = zeros(T,T);

if config.use_costsum <= 1e-6 ...
    && config.use_costcontigevolution <= 1e-6 ...
    && config.use_costcontigpast <= 1e-6 ...
    && config.use_costcontigfuture <= 1e-6 
   SC = zeros( T, W ); 
   return;
end

if config.use_costsum > 1e-3
    C = show.CosineMatrix;
    C(C>=0) = C(C>=0) .* (config.costsum_incentivebalance);
    C(C<0) = C(C<0) .* (1-config.costsum_incentivebalance);
    C = normalize_costmatrix( C ) ...
        .* config.use_costsum;
end

CC = getcosines_contigstatic( show, config );
CE = getcosines_contigevolution ( show, config );

CA = CC + C + CE;
SC = get_summationfast( CA, W );
SC = SC ./ repmat( (1:W).^config.costsum_normalization, size(SC,1), 1 );
SC = normalize_costmatrix( SC );

SC( isnan(SC) ) = inf;
SC(:,1:show.w-1 ) = inf;
    
end

 
 

