function [ SC ] = getcost_symmetry( C, W, min_w  )
%%

T = size(C,1);

assert(size(C,1)==size(C,2));

IN = nan(T, W);

CT = C';

 for t=1:W
     
    IN( 1:T-(t-1), t ) = 1-diag( CT, t-1 ); 
    
 end

 for t=1:T
   % IN( t, 1:W ) = cumsum( IN( t, 1:W ) );
 end
 

SC = inf(T,W);

SC( :, 1 ) = diag(C);

for t=1:T-1
    SC( t, 2 ) =  C( t,t )+C(t+1,t+1)+ 2*C(t,t+1);
end

gw = (1-gausswin(W,1));

for w=3:W
    for t=1:T-w+1
    
        a = SC( t, w-1 );
        b = SC( t+1, w-1 );
        c = SC( t+1, w-2 );
        
        d = C( t, t+w-1 ) *  (IN(t,w)); 
        
        SC( t, w ) = d + a + b - c;
    end
end


%%

SC = normalize_costmatrix( SC );
basic_sizenormalization = repmat( (1:W), size(SC,1), 1);
SC = SC ./ basic_sizenormalization;

SC(:,1:min_w )=inf;



%%

end