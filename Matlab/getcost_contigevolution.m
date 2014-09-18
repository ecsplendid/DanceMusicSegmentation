function [SC] = getcost_contigevolution ( ...
    show, config) 
%getcost_contigdiag1 "Evolving self-similarity" 
%implementation of getcost_contigdiag
%rehashed 15/09/14
%similar concept to the rehash of contig past/future. we now modify the
%cosine matrix in-place. We take each diag /in -1,2,...,W take signs and
%Nth order differences. Then set the sign of the differences to be
%original sign and sum over it with the sum dynamic program. It will look
%for contiguous diagonal traces i.e. songs that evolve in respect of time
% this runs extremely fast O(TW) time 
% the conceptual difference between this and the other contig function is 
% that this doesn't do a cumsum, so we are roughly summing how many evolutionary
% changes there are but can't give give cumulative credit in the same way because 
% tracks would interact with each other. When tracing up and down (as in the contig_static)
% you soon leave the workable area of the cosine matrix and don't interfere with any
% other tracks.

%%
T = show.T;
W = show.W;

if config.use_costcontigevolution <= 1e-6
   SC = zeros( T, W ); 
   return;
end

C = show.CosineMatrix;

diffn = config.costcontig_evolutiondiffwindow;

for w=1:W
    
    d = diag( C, w );
    sg = sign(d);
  
    in = idiag(size(C), w);
    
    C( in((diffn+1):end) ) = ...
        sg( diffn+1:end ) .* ...
        abs( diff( d, diffn ) );
end

%%
show.CosineMatrix = C;

SC = getcost_sum( show, config, ...
    config.use_costcontigevolution, ...
    config.costevolution_incentivebalance, ...
    config.costevolution_normalization );

end
