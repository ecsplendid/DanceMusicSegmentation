function [ SC ] = getcost_sum( show, config, scale, ib, normalization )
%   getcost_sum 
%   builds the sum cost matrix calling the dynamic program get_summationfast
%   which is described in detail in the first paper. Runs in O(2TW)

if nargin < 3
    % this function is used in the context of contig too
    % so we don't always want to use config.usecostsum
    scale = 1;
end

if nargin < 4
    ib = config.costsum_incentivebalance;
end

W = show.W;
C = show.CosineMatrix;

if scale == 0
   SC = zeros( show.T, W ); 
   return;
end

C(C>=0) = C(C>=0) .* (ib);
C(C<0) = C(C<0) .* (1-ib);

SC = get_summationfast( C, W );

SC = SC ./ repmat( (1:W).^normalization, size(SC,1), 1 );

SC = normalize_byincentivebias( SC, ib );

SC( isnan(SC) ) = inf;
SC(:,1:show.w-1 ) = inf;
    
SC = SC .* scale;

end

 
 

