function [SC] = getcost_contigevolution ( ...
    show, config) 
%getcost_contigdiag1 "Evolving self-similarity" 
%implementation of getcost_contigdiag
%rehashed 15/09/14
%similar concept to the rehash of contig past/future. we now modify the
%cosine matrix in-place. We take each diag /in 1,2,...,W take signs and
%Nth order differences. Then set the sign of the differnces to be
%original sign and sum over it with the sum dynamic program. It will look
%for contigious diagonal traces i.e. songs that evolve in respect of time
% this runs extremely fast O(TW) time 

%%
T = show.T;
W = show.W;
w = show.w;

if config.use_costcontigevolution == 0
   SC = zeros( T, W ); 
   return;
end

C = show.CosineMatrix;
C2 = zeros( size( show.CosineMatrix ) );

diffn = config.costcontig_evolutiondiffwindow;

for w=1:W
    d = diag( C, w );
    b = d<0;
    b = b((diffn+1):end);
    
    df = abs(diff(d, diffn));
    d = df;
    d( b ) = -d( b );
    
    in = idiag(size(C), w);
    
    C2( in((diffn+1):end) ) = d;
end

%%
show.CosineMatrix = C2;

SC = getcost_sum( show, config, ...
    config.use_costcontigevolution, ...
    config.costevolution_incentivebalance, ...
    config.costevolution_normalization );

end