function [ SC ] = getcost_sum( show, config, scale, ib )
%   getcost_sum 
%   builds the sum cost matrix calling the dynamic program get_summationfast
%   which is described in detail in the first paper. Runs in O(TW)

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

C_BLUE = C;
C_BLUE(C_BLUE>=0) = 0;
C_BLUE = abs(C_BLUE);

C_RED = C;
C_RED(C_RED<0) = 0;
C_RED = abs(C_RED);

SC_BLUE = get_summationfast( C_BLUE, W, show.w );
SC_RED = get_summationfast( C_RED, W, show.w );

SC_BLUE = SC_BLUE ./ repmat( (1:W).^2, size(SC_BLUE,1), 1 );
SC_RED = SC_RED ./ repmat( (1:W).^2, size(SC_RED,1), 1 );

SC_BLUE = SC_BLUE .* ib;
SC_RED = SC_RED .* (1-ib);

SC_BLUE = -SC_BLUE;

SC = SC_BLUE+SC_RED;

SC = normalize_byincentivebias( SC, ib );

SC( isnan(SC) ) = inf;
SC(:,1:show.w-1 ) = inf;
    
SC = SC .* scale;

end

 
 

