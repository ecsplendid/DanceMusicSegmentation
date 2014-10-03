function results =  ...
    find_posterior( show, config, output_width, results )

% how many tracks to find
M = length(show.indexes)+1;
T = show.T;
W = show.W;
SC = show.CostMatrix;

eta = config.eta;

% to calculate TL and H we need a slightly different cost matrix

HT_SC = SC;

% preprocess SC with the exp 
% doing this doesnt affect the calculation of optimal placement, only
% posterior

HT_SC = exp(-eta * SC );

%
% cost of one track across all times

H = zeros( M, T );
H( 1, 1:W ) = HT_SC(1,:); 

for m=2:M
   for t=m:min(T,W*m) % go from the minimum track placement to maximum
      
       % which s's are relevant (time to which we fill m-1 songs)
       %s is the end of the previous track (m-1)
       s = max( m-1, t-W ):t-1;

       % last song runs from [s+1 .. t]
       % length is t-(s+1)+1 = t-s
       
       H(m,t) =  H(m-1,s) * HT_SC(sub2ind([T,W], s+1, t-s))';
   end
end

%figure(4);
%imagesc(log(H))
%title('head');

%

TL = zeros( M, T ); % cost of best tail partition
TL( 1, (T-W+1):T) = HT_SC(sub2ind([T,W], T-W+1:T,W:-1:1));

for m=2:M
  % from which positions t can one pack m tracks until T?
  % earliest: T-m*W (or 1 if this is negative)
  % latest:   T-m
  % TODO: check off-by-ones

    for t=max(T-m*W,1):T-m
        
         s = t+1:min(t+W,T);

	 % last song runs from [t .. s-1]
	 % length: (s-1)-t+1 = t-s
        
         TL(m, t) =  TL(m-1, s ) * HT_SC( t, s-t)';
    end
end

%figure(3);
%imagesc(log(TL))
%title('tail');
%colorbar;

% We computed the cost of packing 1:M tracks between start and end in 2 ways.
% these should be identical (perhaps up to numerical errors)
%assert(all(abs(H(:,T) - TL(:,1)) <= 1e-6 * H(:,T)));

% calculate the posterior for boundary

PB = nan(M, T); % distribution of M track starting positions

PB(1,:) = [TL(M, 1)/H(M,T) zeros(1,T-1)]; % first track must start at start :)

for m=2:M
       PB(m,1) = 0; % cannot start second track at start

       % place m-1 tracks until yesterday, then fill up with M-m+1 tracks until the end
       PB(m,2:T) = ( ( H(m-1,1:T-1) ) .* TL( M-m+1,2:T) ) / H(M,T);
end

% PB is normalised *by definition*
%assert(all(abs(sum(PB,2) - 1) < 1e-6));

if( config.draw_confs == 1) 
    figure(15);
    imagesc(log(PB));
    title('probability distribution');
    colorbar;
end

if ~config.memory_efficient
    results.posterior = PB;
end

% calculate the posterior for song position (hard to visualize probably wont for paper)

% PP = nan( M, T, T );
% 
% for m=2:M
%     for s = 2:T-1
%         for f = (s+1):min(s+W-1,T-1)
%             
%            PB(m,2:T) = ( ( H(m-1,1:T-1) ) .* TL( M-m+1,2:T) ) / H(M,T);
%             
%            % normalized in respect of the total minimum cost of placing all
%            % tracks (M,T)
%            PP( m, s, f ) = ( ( H( m-1, s-1 )  ) *  SC( s, f-s+1  ) * TL( M-m+1, f+1 ) ) / H( M, T );
% 
%            % normalize each track row (not in the paper yet)
%            %P( m,: ) = P( m,: ) ./ max( P( m,: ) );
%        
%         end
%     end
% end

%title('probability posterior for track 5 starting at times s,f');
%imagesc( log( squeeze( PP( 5,:,: ) ) ))
%colorbar

% plot the song cost matrix

%figure(1)

%imagesc(SC)
%title('song cost matrix')
%axis xy;
%colorbar;

% Finding the best track placement for comparison (unchanged from the first paper)

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


% new uncertainty calculation (of correct track INDEX)
% all we are doing is taking the biggest peaks (on the vertical trace)
% and looking at how similar they are, smaller divided by bigger

relative_uncertainty = nan(M,1);

for m=1:M
    
    track_probs = PB(:, best_begin(m) );
    
    l = sort(track_probs,'descend');
    
    relative_uncertainty(m) = l(2)/l(1);
end

confidence = 1 - relative_uncertainty;

if( config.draw_confs == 1) 
    figure(7)
    bar( confidence );
    title(sprintf('Track Alignment Confidence Level\n%s', show.showname));
    xlabel('Track Number');
    ylabel('Confidence Level');
end

results.mean_indexplacementconfidence = mean(confidence);
results.worst_indexplacementconfidence = min(confidence);
results.track_indexconfidences = resample_matrix( confidence', output_width);

%% new uncertainty calculation (of correct track TIME)

track_placementconf = nan( M, 1 );
track_placementconf(1) = 1;

for m=2:M

    track = PB( m,: );

    [pks,locs] = findpeaks(track);

    [vals, ix] = sort( pks,'descend' );

    if length( vals ) == 1
        track_placementconf(m) = 1;
    else
        track_placementconf(m) = 1 - (pks( ix(2) ) / pks( ix(1) ));
    end
end

if( config.draw_confs == 1) 
    figure(9)
    bar( track_placementconf );
    title(sprintf('Track Time Placement Confidence\n%s',show.showname));
    ylabel ( 'Confidence Level' );
    xlabel( 'Track Number' );
end

results.track_placementconfidenceavg = mean(track_placementconf);
results.track_placementconfidence = resample_matrix(track_placementconf', output_width);


plot(track_placementconf)

%% how close is our posterior probability distribution?

if( config.draw_confs == 1) 

    figure(15);

    hold on;
    for t=1:length(best_begin)
       %overlay the best track placement from first paper on top of image map
       plot(best_begin(t),t,'w*');
    end
    hold off;

    title(sprintf('Posterior with the "best" tracks overlaid\n%s',show.showname));
    xlabel('Tiles');
    ylabel('Track Number');
    colorbar;
end

% %% plot the original cost matrix with the optimal track placement
% if( draw_figs == 1) 
%     figure(5);
% 
%     imagesc(C);
%     axis xy;
%     colorbar;
%     hold on;
%     for t=1:length(best_begin)
%        %overlay the best track placement from first paper on top of image map
%        plot(best_begin(t),best_begin(t),'w*');
%     end
%     hold off;
% end

end 
