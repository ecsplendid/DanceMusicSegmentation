function [ SC ] = getcost_sum( C, W, min_w, ...
    costsum_incentivebalance )
%   getcost_sum 
%   builds the sum cost matrix calling the dynamic program get_summationfast
C_BLUE = C;
C_BLUE(C_BLUE>=0) = 0;
C_BLUE = abs(C_BLUE);

C_RED = C;
C_RED(C_RED<0) = 0;
C_RED = abs(C_RED);

SC_BLUE = get_summationfast( C_BLUE, W, min_w );
SC_RED = get_summationfast( C_RED, W, min_w );

SC_BLUE = SC_BLUE ./ repmat( (1:W).^2, size(SC_BLUE,1), 1 );
SC_RED = SC_RED ./ repmat( (1:W).^2, size(SC_RED,1), 1 );

SC_BLUE = SC_BLUE .* costsum_incentivebalance;
SC_RED = SC_RED .* (1-costsum_incentivebalance);

SC_BLUE = 1-SC_BLUE;

SC = SC_BLUE+SC_RED;

SC(isnan(SC)) = inf;
SC(:,1:min_w )=inf;

SC = normalize_byincentivebias( SC, costsum_incentivebalance );

    
end

 
 

