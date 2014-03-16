function [SC] = getcost_contig(C, W, min_w) 
%%
T = size(C,1);

SC = inf( T, W );

gs = 1-gausswin(W,5).*0.7;

for w=min_w:W
    for t=1:T-w+1

        % we have the triangle
        C_square = C( t:t+w-1, t:t+w-1 );
        
        inds = 1:size(C_square,1)^2;
        
        C_line = C_square(inds);
        
        summation = sum( C_line ) /  (w+min_w);
        
        C_linesorted = sort( C_line );
       
        d = diff( C_linesorted );
        
        mean_positivediff = ( ( ( mean( d(d>0) )*w^2  )  )  );
       
        SC( t, w ) = mean_positivediff * summation;

    end
    
    imagesc(SC);
    colorbar;
    drawnow;
end

SC(:,1:min_w )=inf;
SC = normalize_costmatrix(SC);

%[predictions, matched_tracks, avg_shift] = compute_trackplacement( ...
%        showname, SC, drawsimmat, space, indexes, solution_shift, tileWidthSecs, C, w );
 
%
end