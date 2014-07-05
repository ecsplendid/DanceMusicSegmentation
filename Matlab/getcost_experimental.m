function [SC] = getcost_experimental(...
    C, W, min_w, ...
    incentivebalance, window_size ) 

%%

T = size(C,1);
SC = inf( T, W );
C_bigdags = getmatrix_indiagonals(C, 1, W);

for width=min_w:W
    for t=1:T-width+1
        %%
        
        % we have the triangle
        C_dags = C_bigdags(1:width, t:t+width-1);
        
        numberOfDecimalPlaces = 1;
        factorOf10 = 10^numberOfDecimalPlaces;
        C_dagsdisc = round(C_dags .* factorOf10) ./ factorOf10;

       % cost = cov( ...
       %      sum(triu(fliplr(C_dagsdisc)),2)'  ...
       %      );
       
        a = C_dags( 1:width^2 );

        ss = sign(a);

        ft = sqrt(mean(abs(fft( a )).^3));

        cost = ft;
        
        
        
        %%
        SC(t, width) = cost;
    end
end

SC = normalize_byincentivebias(SC, 0.5);

SC(:,1:min_w-1 )=inf;


end