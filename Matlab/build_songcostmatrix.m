function [ SC ] = build_songcostmatrix( C, W )
%   BUILD_SONGCOSTMATRIX Summary of this function goes here
%   type is default 'area', or 'symetry'
%   C is cost matrix
%   T is total time in seconds
%   W is the largest song width

%% build SC song cost cache matrix (l in paper)

T = size(C,1);

assert(size(C,1)==size(C,2));

SC = inf(T,W);

SC( :, 1 ) = diag(C);

for t=1:T-1
    SC( t, 2 ) =  C( t,t )+C(t+1,t+1)+ 2*C(t,t+1);
end

for w=3:W
    for t=1:T-w+1
    
        a = SC( t, w-1 );
        b = SC( t+1, w-1 );
        c = SC( t+1, w-2 );
        %d = C( t, t+w-1 )*2; % here we use symmetry
        
        
       
        d = C( t, t+w-1 );
      
        
        SC( t, w ) = d + a + b - c;
        
    end
end
    
    
end

 
 

