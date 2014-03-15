%function [SC] = getcost_contig(C, W, min_w) 
%%
T = size(C,1);

SC = inf( T, W );


for w=min_w:W
    for t=1:T-w+1


        % we have the triangle
        sq = C( t:t+w-1, t:t+w-1 );
        
        ln = sq( 1:size(sq,1)^2 )';

        [ls] = sort( ln );
        
        %plot(ls)
        
       % SC( t, w ) = ls( floor(w^2/2) ) / (w);
       
       d = diff( ls );
       
       SC( t, w ) = mean( d(d>0) );
       
        
    end
    
    imagesc((SC));
    colorbar;
    drawnow;
end


SC(:,1:min_w )=inf;


SC = normalize_costmatrix(SC);

[predictions, matched_tracks] = compute_trackplacement( ...
        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, w );

%%

imagesc(SC)


%%
%end