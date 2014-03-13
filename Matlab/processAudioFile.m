function [ matched_tracks predictions, SC, C ] = processAudioFile( ...
    sampleRate, indexes, audio_low, secondsPerTile, ...
    minTrackLength, maxExpectedTrackWidth, bandw, lowPassFilter, highPassFilter, ...
    drawSimMat, drawcost,...
   drawpreds, ...
      solution_shift, costmatrix_parameter, costmatrix_normalizationtype, ...
     use_contiguity,contig_thresh, contiguity_parameter, contiguity_gaussscale ...
 ,gaussian_filterdegree, noplace_thresh, noplace_exponent, ...
 amount_negdiffmap,amount_posdiffmap,amount_noplacemap,amount_diffmap,amount_contiguity, ...
 diffmap_transient, amount_allscale, cost_transformexponent, cost_transformfilter, selfsim_disincentivefactor, ...
 sc_scalefactor)


%secondsPerTile = 1;
nTiles = ceil((length(audio_low)/sampleRate)/secondsPerTile);
tileWidth = floor(length(audio_low)/nTiles); % we discard the last partial tile

%nFFT = 2^nextpow2(tileWidth);
nFFT = 2^nextpow2( tileWidth );

totalSecs = length(audio_low)/sampleRate;
tileWidthSecs = tileWidth/sampleRate;

maxExpectedTrackWidthTiles = ceil((maxExpectedTrackWidth)/tileWidthSecs);  % in tiles
%bandw = 5;%Hz
%lowPassFilter = 2000;%Hz
lowPassFilterSamples = ceil(lowPassFilter * (nFFT/sampleRate))+1;
%highPassFilter = 150;%Hz
highPassFilterSamples = ceil(highPassFilter * (nFFT/sampleRate))+1;
assert( lowPassFilterSamples < nFFT/2 );

fdata = nan( nTiles, (lowPassFilterSamples-highPassFilterSamples)+1  );

bandw_fftSpace = ( bandw * (nFFT/sampleRate) ); % in FFT steps
gaussParams=-ceil(2*bandw_fftSpace):ceil(2*bandw_fftSpace);
gaussFirstDerivative = -exp(- gaussParams.^2/bandw_fftSpace^2) .* (2*gaussParams/bandw_fftSpace^2);

gaussParams=-ceil(2*bandw_fftSpace):ceil(2*bandw_fftSpace);

gaussFirstDerivative = -exp(- gaussParams.^gaussian_filterdegree/bandw_fftSpace^2) .* (2*gaussParams/bandw_fftSpace^2);

tileindexes = (1:tileWidth);

stepsize = 150;
fsize = 320;
newfilt = zeros(fsize,1);
newfilt(((fsize/2)-(stepsize/2)):(fsize/2)) = 1;
newfilt(((fsize/2)+1):((fsize/2)+(stepsize/2))+1) = -1;

for x=1:nTiles
    
    dft = fft( audio_low( tileindexes+(x-1)*tileWidth ),nFFT);
    
    Y = abs(dft( highPassFilterSamples:lowPassFilterSamples ));

	Y = abs(conv(  Y, gaussFirstDerivative,'same' ));

    Y = Y./norm(Y); %normalize (unit length) vec, so dot below gives cosines;
    
    assert((norm(Y)-1)<1e-6);
    
    fdata(x, : ) = Y;
   
end


space = (0:nTiles-1) .* tileWidthSecs;


%%
C = 1-(fdata * fdata');

%C = conv2( C, cost_transformfilter, 'same' );

C_exp = 1 - ((1-C).^cost_transformexponent);

blank_tiles = floor((minTrackLength)/tileWidthSecs);

SC = (build_songcostmatrix( C, maxExpectedTrackWidthTiles ));
SC(:,1:blank_tiles )=inf;

% contiguity map
[T,~] = size( C );
[~,W] = size( SC );

SYM = find_symmetrycostmatrix( C_exp, W, blank_tiles, T );

%%


ms = max( SC( 1:end-W,end ) );SC = SC./ms;

% basic track size normalization % on all, we normalize on W
basic_sizenormalization = repmat( (1:W), size(SC,1), 1);
SC = SC ./ basic_sizenormalization;



ms = max( SC( 1:end-W,end ) );SC = SC./ms;


if( use_contiguity > 0 )

    selfsim_map = inf( T,W );
    for t=1:T
        selfsim_map(t, 1:min(W,T-t+1) ) = C_exp( t, t:min(t+W-1,T) );
    end

    selfsim_indexdisincentive = zeros( T, W );
    
    for t=1:T
        for w=1:min(W,T-t)
            
            selfsim_indexdisincentive( t, w ) = sum( 1-selfsim_map(t, 1:w) ) ;

        end
    end
  
    selfsim_indexdisincentive = selfsim_indexdisincentive./ max(max(selfsim_indexdisincentive));

    selfsim_map_close = selfsim_map;
    selfsim_map_close(selfsim_map_close > contig_thresh ) = nan;
	selfsim_map_close(selfsim_map_close <= contig_thresh ) = 1;
    selfsim_map_close(isnan(selfsim_map_close)) = 0;
    
    contig_map = zeros( T, W );
    
    for t=1:T
       
        contig_map( t,: ) = conv( selfsim_map_close( t,: ), gausswin(5) , 'same' );
        
        cs = zeros( 1,W );
        last_high = 0;
        for i=2:W %% do the cum sum thing
            if contig_map( t,i ) == 0
                cs(i) = 0;
                last_high = max(cs);
            else
                cs(i) = min(inf, cs(i-1)+contig_map(t,i) );
            end
        end
        
        contig_map( t,: ) = cs;
       
        contig_map( t,: ) = contig_map( t,: ) .* gausswin(W,contiguity_gaussscale)';
    end
    
    contig_map = (contig_map ./ max(max(contig_map)));

    diff_map = diff( contig_map );
    diff_map = -diff_map;
    diff_map = [zeros( 1, W ); diff_map; ];

    negdiff_map = diff_map;
    relevant_neg = diff_map>diffmap_transient;
    negdiff_map(relevant_neg) = 1;
    negdiff_map(not(relevant_neg)) = 0;
    
    posdiff_map = diff_map;
    relevant_pos = diff_map<-diffmap_transient;
    posdiff_map(relevant_pos) = 1;
    posdiff_map(not(relevant_pos)) = 0;
   
    posdiff_map = posdiff_map .* repmat( (1:W).^contiguity_parameter, size(SC,1), 1); 
    negdiff_map = negdiff_map .* repmat( (1:W).^contiguity_parameter, size(SC,1), 1); 
    
    noplace_map = inf( T,W );
    for t=1:T
        noplace_map(t, (blank_tiles+1):min(W,T-t+1) ) = C( t, (t+blank_tiles):min(t+W-1,T) );
    end

    noplace_map(isinf(noplace_map)) = 0;
    
    map_dissimilar = noplace_map >= noplace_thresh;
    map_others = not( map_dissimilar );
    
    noplace_map( map_others ) = 0;
    noplace_map( map_dissimilar ) = 1;
  
   % noplace_map = 1-noplace_map;
    noplace_map(:,1:blank_tiles )=0;
    
    for t=1:T
        noplace_map( t,: ) = noplace_map( t,: ) .* ( (1:W) .^ noplace_exponent );
    end
    
	noplace_map = (noplace_map ./ max(max(noplace_map)));
    noplace_map = 1-noplace_map;
end

if( use_contiguity > 0 )

    sc_inf = isinf(SC);
    
    %prenormalize 
    ms = max( SC( 1:end-W,end ) );
    SC = SC./ms;
    
    new_map = zeros( T, W);
    
    if amount_noplacemap > 0
        
        new_map = new_map +(1-(noplace_map.*amount_noplacemap)); 
    end
    
    if amount_negdiffmap>0
        
        new_map = new_map +((negdiff_map.*amount_posdiffmap)); 
    end
    
    if amount_posdiffmap > 0  
        new_map = new_map -((posdiff_map.*amount_posdiffmap)); 
    end
    
    if amount_contiguity > 0 
        new_map = new_map - ((contig_map).*amount_contiguity);
    end
    
    if( selfsim_disincentivefactor > 0 )
        
         new_map = new_map + ((selfsim_disincentivefactor).*selfsim_indexdisincentive);
    end
    
    new_map = new_map + ((SYM).*5);
    
    new_map = (new_map.*amount_allscale) + (SC.*sc_scalefactor);
    SC = new_map;
    
	ms = max( SC( ~isinf( SC ) ) );
	mis = min( SC( ~isinf( SC ) ) );
   
    SC = (SC - mis) ./ (ms - mis);
    
    imagesc(SC)
    
else

end


% perform scaling
if( costmatrix_normalizationtype == 1) % 1, favor short tracks

    SC = SC .* repmat( (W:-1:1).^costmatrix_parameter, size(SC,1), 1);
end

if( costmatrix_normalizationtype == 2) %2 favor long tracks exponentially, if costmatrix_parameter==1, will normalize on track length

    SC = SC .* repmat( (1:W).^costmatrix_parameter, size(SC,1), 1);  
end

if( costmatrix_normalizationtype == 3) %3 fit gaussian
    
	window_matrix_gauss = repmat( (( gausswin(W) .* costmatrix_parameter ))', size(SC,1), 1  );
 
    SC = (SC + 1) - window_matrix_gauss;
end

% normalize it so we dont break wouters assertion in posterior
ms = max( SC( ~isinf( SC ) ) );
SC = SC./ms;

SC(:,1:blank_tiles )=inf;

[L best_begin] = find_tracks( length(indexes)+1, SC );

best_begin_tilespace = best_begin;
indexes_tilespace = indexes ./ tileWidthSecs;

best_begintiles = best_begin';
best_begin = space( best_begin );
predictions = best_begin(2:end);

predictions = predictions + solution_shift;

[matched_tracks] = evaluate_performance(indexes, best_begin(2:end));
if drawSimMat == 1
    figure(1)
   % imagesc(space,space, sim_mat_fft);daspect([1 1 1]);colorbar;colorbar;axis xy;
   %  imagesc(space,space, C);daspect([1 1 1]);colorbar;colorbar;axis xy;
   
     imagesc(C);daspect([1 1 1]);colorbar;colorbar;axis xy;
   if drawpreds == 1
    draw_rectangles( [best_begin_tilespace nTiles .* tileWidthSecs], 'k' );
   end
    draw_indexes(space(end)./indexes_tilespace, indexes_tilespace);
    xlabel('Tiles');
    ylabel('Tiles');
    
    mean(abs(indexes - best_begin(2:end)'))

    if(drawcost)
        figure(2)
        imagesc(SC);
        draw_scindexes(best_begintiles);
    end

end

%%
end
