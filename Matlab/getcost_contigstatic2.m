function [SC] = getcost_contigstatic2(...
    show, config ) 
 %getcost_contigstatic2 110914 
 % re-hash of contigous cost matrix concept
 % now the idea is we modify the cosine matrix in-place, and sum over
 % changes
 % we set the non-used half to zero
 % we work on two conceptualizations, "past" and "future"
 % past means we trace downwards from main diag, future accross
 % then we conv a hamming window up and down the matrix for each one
 % and then do a cumsum on both to give a basic increased score for contig
 % then we build other matrices to punish non-contiguity, this is created
 % from Nth order differences of smoothed matrices, cumsumed, scaled and
 % factored out
 % parameters are 1) diff order, 2) penalty scaling exponent
 
%%

T = show.T;
W = show.W;
C = show.CosineMatrix;
ibp = config.costcontigpast_incentivebalance;
ibf = config.costcontigfuture_incentivebalance;

if config.use_costcontigpast == 0 ...
        && config.use_costcontigfuture == 0
   SC = zeros( T, W ); 
   return;
end

for t=1:T
    C( t, 1:t ) = 0;
end

C2=C;

C2 = normalize_byincentivebias(C2, 0.5);
C2(C2>0) = 1;
C2(C2<=0) = -1;

normalize = @(sc)(sc - min(min(sc))) ./ ...
    max( max( sc(~isinf(sc)) ) - min( min( sc ) ) );

%% future

fut_penalty = diff( C2, config.costcontig_futurediffwindow, 2 );
fut_penalty = fut_penalty>0;
fut_penalty = cumsum(fut_penalty')';
fut_penalty = normalize(fut_penalty);
fut_penalty = fut_penalty.^config.contig_penalty;  % how quickly to penalize non contiguity
fut_penalty = [fut_penalty zeros(T, config.costcontig_futurediffwindow)];
fut_penalty = 1-fut_penalty;

%% past

pas_penalty = diff( C2, config.costcontig_pastdiffwindow );
pas_penalty = pas_penalty>0;
pas_penalty = flipud(cumsum(flipud(pas_penalty)'));
pas_penalty = normalize(pas_penalty);
pas_penalty = pas_penalty.^config.contig_penalty;  % how quickly to penalize non contiguity
pas_penalty = 1-pas_penalty;
pas_penalty = [pas_penalty zeros(T, config.costcontig_pastdiffwindow ) ];

%%
Cpast = (flipud(cumsum(flipud(pas_penalty.*C)))')';
Cfuture = cumsum((fut_penalty.*C)')';

SC = zeros( T, show.W );

if config.use_costcontigpast > 0
    show.CosineMatrix = Cpast;
    SCP = getcost_sum( show, config, config.use_costcontigpast, ibp, ...
        config.costcontig_normalization );
    SC = SC + SCP;
end

if config.use_costcontigfuture > 0
    show.CosineMatrix = Cfuture;
    SCF = getcost_sum( show, config, config.use_costcontigfuture, ibf, ...
        config.costcontig_normalization );
    SC = SC + SCF;
end

SC(:,1:show.w-1 )=inf;

end