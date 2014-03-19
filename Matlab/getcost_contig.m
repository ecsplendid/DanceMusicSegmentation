function [SC] = getcost_contig(...
    C, W, min_w, ...
    costcontig_incentivebalance) 
%%
T = size(C,1);
SC = inf( T, W );

gwin_large = gausswin(W);

%%
tic;
for w=min_w:W
    for t=1:T-w+1
%%
        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        C_dags = getmatrix_indiagonals(C_square, 1);

        red = abs(C_square(C_square>0));
        blue = abs(C_square(C_square<=0));
        
        high_thresh = mean( red );
        low_thresh = -(mean( blue ));
        
        if(isnan(high_thresh)), high_thresh=0; end;
        if(isnan(low_thresh)), low_thresh=0; end;
        
        % we are looking for adjacent blues and reds
        % on the diags away from center
        
        gwin = gausswin(w);
        
        score = 0;
        
         % for every dag (no point looking at first one though)
        for d=2:size( C_dags, 1 )
            
            C_line = C_dags( d, 1:size( C_dags, 1 )-d+1 );

            for i=2:length( C_line )

                le = C_line(i-1);
                ri = C_line(i);

                mix = mean(abs(le)+abs(ri));

                newscore = (mix);
                % contiguity more important in the center 
                % of the expected track size
                newscore = newscore * gwin(w);
                % contiguity more important the further away it is
                newscore = newscore / d;

                if( le < low_thresh && ri < low_thresh)
                   newscore = newscore * costcontig_incentivebalance;
                   score = score - newscore;
                end

                if(  le > high_thresh && ri > high_thresh )
                    newscore = newscore * (1-costcontig_incentivebalance);
                    score =  score + newscore;

                end
            end
        end
        
        SC(t, w) = score;
 %%
    end
    
end
toc;

SC = normalize_byincentivebias(SC, costcontig_incentivebalance);

SC(:,1:min_w )=inf;




end