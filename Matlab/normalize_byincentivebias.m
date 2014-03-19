function [ SC ] = normalize_byincentivebias( SC, incentive_bias )
%normalize_byincentivebias This will return an SC 
% on the [-1,1] interval when incentive_bias = 0.5
% [-1, 0] when incentive_bias=1
% [0, 1] when incentive_bias=0
%%
NSC = SC;

interval_size = 2 - ((abs(0.5-incentive_bias))*2);

shift = 1;

if( incentive_bias<0.5 )
    shift = shift - abs( 0.5 - incentive_bias )*2;
end

% normalize to [0,1]
NSC= (SC - min(min(SC))) ./ max( max( SC(~isinf(SC)) ) - min( min( SC ) ) );

% normalize to ([0,interval_size])
NSC = NSC .* interval_size;

% shift down
NSC = NSC - shift;
    
%%
SC = NSC;

end

