function [ SC ] = getcost_sum( C, W, min_w, sum_regularization )
%   BUILD_SONGCOSTMATRIX Summary of this function goes here
%   type is default 'area', or 'symetry'
%   C is cost matrix
%   T is total time in seconds
%   W is the largest song width
%   uses dynamic programming to get it fast

%% build SC song cost cache matrix (l in paper)

% we need it on the [-1 1] interval
% otherwise we are basically adding up the red cells and ignoring the blue
% ones!
CI = (C.*2)-1;

T = size(CI,1);

assert(size(CI,1)==size(CI,2));

SC = inf(T,W);

SC( :, 1 ) = diag(CI);

for t=1:T-1
    SC( t, 2 ) =  CI( t,t )+CI(t+1,t+1)+ 2*CI(t,t+1);
end

for w=3:W
    for t=1:T-w+1
    
        a = SC( t, w-1 );
        b = SC( t+1, w-1 );
        c = SC( t+1, w-2 );
        d = CI( t, t+w-1 )*2; 
        SC( t, w ) = d + a + b - c;
        
    end
end
    
% basic track size normalization % on all, we normalize on W
basic_sizenormalization = repmat( (1:W).^sum_regularization, size(SC,1), 1);
SC = SC ./ basic_sizenormalization;
SC = normalize_costmatrix( SC );


SC(:,1:min_w )=inf;
    
end

 
 

