function [ SC ] = getcost_symmetry( C, W, min_w  )
%%

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
        
        a=0;b=0;c=0;
        
        d = ( ( C( t, t+w-1 ) * C( t, t ) ) ); 
        
        SC( t, w ) = d + a + b - c;
        
    end
end

basic_sizenormalization = repmat( (1:W), size(SC,1), 1);
SC = SC ./ basic_sizenormalization;

SC = normalize_costmatrix( SC );




SC(:,1:min_w )=inf;

%imagesc(SC)

%%

end