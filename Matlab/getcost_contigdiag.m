function [SC] = getcost_contigdiag (...
    C, W, min_w, costcontig_incentivebalance) 
%getcost_contigdiag "Evolving self-similarity" This reference implementation 
%looks at contigous elements in the diagonal and does a normalization based 
%on how far away the contiguity is. The best intuative explanation for it 
%is that it looks for copies of the track being played in the future that
%critically evolve with time. Anything far away from the main diagonal is a
%copy but the more square it is, the less it is evolving with respect of
%time. This cost matrix captures contigous *evolution*

%%
T = size(C,1);
SC = inf( T, W );

%%
for w=min_w:W
    for t=1:T-w+1
%%
        C_line = getmatrix_indiagonals( C( t:t+w-1, t:t+w-1 ), 2);
        
        % we are looking for adjacent blues and reds
        % on the diags away from center
        score = 0;
        
        len_cline = length( C_line );
        
        %precomute the normalization for speed
        factors = (((1:len_cline)./len_cline).^-2).*w;
        
        for i=2:len_cline

            p1 = C_line(i-1);
            p2 = C_line(i);

            if( max(p1, p2) < 0)
                new_cost = (abs(p1)+abs(p2))/2;
                % contiguity more important in the center 
                % of the expected track size
                % contiguity more important the further away it is
                new_cost = new_cost / factors(i);
                new_cost = new_cost * costcontig_incentivebalance;
                score = score + -new_cost;
            end

            if( min(p1,p2) > 0 )
                new_cost = (abs(p1)+abs(p2))/2;
                % contiguity more important in the center 
                % of the expected track size
                % contiguity more important the further away it is
                new_cost = new_cost / factors(i);
                new_cost = new_cost * (1-costcontig_incentivebalance);
                score = score + new_cost;
            end
      
        end
        
        SC(t, w) = score;
 %%
    end
end

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w-1 )=inf;


end