

T = size(C,1);

SC = zeros( T, W );


%for t=1:T-(W+2)


[SC] = getcost_symmetry_triangle( SC, C, 99, W, costsymmetry_incentivebalance );
 
[SC] = getcost_symmetry_triangle( SC, C, 102, W-1, costsymmetry_incentivebalance );

	%[SC] = getcost_symmetry_triangle( SC, C, t, W+1, costsymmetry_incentivebalance );

%end

%SC = SC ./ repmat( (1:W), size(SC,1), 1 );

SC = normalize_byincentivebias( SC, costsymmetry_incentivebalance );
SC(:,1:min_w) = inf;

imagesc(SC)