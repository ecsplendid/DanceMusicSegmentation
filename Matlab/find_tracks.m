function [L best_begin] = find_tracks( M, SC )

% number of tracks we want to find
% cost matrix(t,j) cost of song width j starting at time t

[T W] = size(SC);

V = -inf( M, T );
P = nan( M, T ); % points to end of previous song in best partition

%cost of one track accross all times
V( 1,1:W ) = SC(1,1:W); 

V(1,W+1:end) = inf; % set remaining stuff to inf (too long for song)

for m=2:M
   for t=m:min(T,W*m)
      
       % which s's are relevant (time to which we fill m-1 songs)
       %s is the end of the previous track (m-1)
       s = max( m-1, t-W ):t-1;
       
       [V(m,t) ind] = min( V(m-1,s) + SC((t-s-1)*T+s+1) );
       P(m,t) = s(ind);
   end
   
   V(m,min(T,W*m)+1:end) = inf;
end

% extract the best partition (we give all the song ends)
best_end = nan(1,M);
best_end(M) = T;

for m = M-1:-1:1
    best_end(m) = P(m+1,best_end(m+1));
end

% output
best_begin = [1 best_end(1:end-1)+1];
L = V(end,end);

assert(L~=-inf);

end

