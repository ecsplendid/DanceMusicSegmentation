
%load in a test song cost matrix
load ws2

M = 22; % how many tracks to find
[T,W] = size(SC); % tiles and maximum track width

eta = 1e-3; %learning rate


%% to calculate TL and H we need a slightly different cost matrix

%we don't want infs, rather we want all the non used values to be the min

HT_SC = SC;
mc = min(min(HT_SC));
HT_SC(HT_SC==inf)=0;
HT_SC(HT_SC==0) = mc;

% preprocess SC with the exp 
% doing this doesnt affect the calculation of optimal placement, only
% posterior

%HT_SC = exp(-eta .* HT_SC ); % *** TRY COMMENTING THIS OUT ***


%%
% cost of one track accross all times

H = zeros( M, T );
H( 1, 1:W ) = HT_SC(1,:); 

for m=2:M
   for t=m:min(T,W*m) % go from the minimum track placement to maximum
      
       % which s's are relevant (time to which we fill m-1 songs)
       %s is the end of the previous track (m-1)
       s = max( m-1, t-W ):t-1;
       
       H(m,t) =  H(m-1,s) * HT_SC( t, 1:length(s) )';
   end
   
end

figure(4);
imagesc(log(H))
title('head');




%%

TL = ones( M, T ); % cost of best tail partition
TL( 1, (T-W+1):T) = HT_SC( T, : );

for m=2:M
    for t=min(T,W*m):-1:m
        
        s = max(1,t-W+1):t;
        
        TL(m, t) = sum( TL(m-1, s ) * HT_SC( t, 1:min(W,t) )' );
    end
end

figure(3);
imagesc(log(TL))
title('tail');
colorbar;

%% calculate the posterior for boundary

P = nan( M, T );

for m=2:M
       % normalized in respect of the total minimum cost of placing all
       % tracks (M,T)
       P( m,1:T ) = ( ( H(m-1,1:T) ) .* TL( m-1,1:T ) ) ./ H(M,T);
       
       % normalize each track row (not in the paper yet)
       P( m,: ) = P( m,: ) ./ max( P( m,: ) );
end

figure(2);
imagesc(P);
title('probability distribution')
colorbar;

%% calculate the posterior for song position (hard to visualize probably wont for paper)

PP = nan( M, T, T );

for m=2:M
    for s = 2:T-1
        for f = (s+1):min(s+W-1,T-1)
            
           % normalized in respect of the total minimum cost of placing all
           % tracks (M,T)
           PP( m, s, f ) = ( ( H( m-1, s-1 )  ) *  SC( s, f-s+1  ) * TL( M-m+1, f+1 ) ) / H( M, T );

           % normalize each track row (not in the paper yet)
           %P( m,: ) = P( m,: ) ./ max( P( m,: ) );
       
        end
    end
end

%title('probability posterior for track 5 starting at times s,f');
%imagesc( log( squeeze( PP( 5,:,: ) ) ))
%colorbar

%% plot the song cost matrix

figure(1)

imagesc(SC)
title('cost function matrix')
axis xy;
colorbar;

%% Finding the best track placement for comparison (unchanged from the first paper)

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

figure(6)
imagesc(V)
title('V matrix for calculating the optimum track placement (note inf step on the left comes from SC, copied in here)')


%% how close is our posterior probability distribution?

figure(2);

hold on;
for t=1:length(best_begin)
   %overlay the best track placement from first paper on top of image map
   plot(best_begin(t),t,'w*');
end
hold off;

title('posterior with the "best" tracks overlaid');
colorbar;

%% plot the original cost matrix with the optimal track placement
figure(5);

imagesc(C);
axis xy;
colorbar;
hold on;
for t=1:length(best_begin)
   %overlay the best track placement from first paper on top of image map
   plot(best_begin(t),best_begin(t),'w*');
end
hold off;
title('the original cost (cosine) matrix with track placement for sanity checking');

