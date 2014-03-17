function [ SC ] = getcost_symmetry( C, W, min_w, ...
    contig_symmetrythreshold, ...
    costsymmetry_incentivebalance )
%%
T = size(C,1);

SC = inf( T, W );
SC_incentive = inf( T, W );
SC_disincentive = inf( T, W );

for w=min_w:W
    for t=1:T-w+1

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_dags = getmatrix_indiagonals(C_square, 1);
        
        incentive_score = 0;
        disincentive_score = 0;
        
        % for every dag (no point looking at first one though)
        for i=2:size( C_dags, 1 )
            
            d1 = C_dags( i, 1:size( C_dags, 1 )-i+1 );
            d2 = fliplr( d1 );
            
            % compare every symmetric pair
            for p=1:size( C_dags, 1 )-i
                
                avg = (d1(p)+d2(p))/2;
                
                if( d1(p) < contig_symmetrythreshold && d2(p) < contig_symmetrythreshold )
                   
                    incentive_score = incentive_score +  ...
                        ( (1-avg) );
                end 
            
                if( d1(p) > (contig_symmetrythreshold) && d2(p) > (contig_symmetrythreshold) )
                   
                    disincentive_score = disincentive_score + ...
                        ( avg );
                end 
            end
            
            
        end
        
        SC_incentive(t, w) = incentive_score;
        SC_disincentive(t, w) = disincentive_score;

    end
    
   %imagesc(SC);
   % colorbar;
   % drawnow;
end

SC = -(SC_incentive.*costsymmetry_incentivebalance + ...
    -SC_disincentive.*(1-costsymmetry_incentivebalance));

SC = normalize_costmatrix(SC);

SC = SC-costsymmetry_incentivebalance;

SC(:,1:min_w )=inf;


%%

end