function [C2] = getcosines_contigevolution ( ...
    show, config) 
%getcosines_contigevolution "Evolving self-similarity" 
%implementation of getcost_contigdiag
%rehashed 150904,200914
%similar concept to the rehash of contig past/future. we now modify the
%cosine matrix in-place. We take each diag /in -1,2,...,W take signs and
%Nth order differences. Then set the sign of the differences to be
%original sign and sum over it with the sum dynamic program. It will effectively look
%for contiguous diagonal traces i.e. songs that evolve in respect of time
% this runs extremely fast O(TW) time 

%%

W = show.W;
T = show.T;

if config.use_costcontigevolution <= 1e-6
   C2 = zeros( T, T ); 
   return;
end

C = show.CosineMatrix;

diffn = config.costcontig_evolutiondiffwindow;
ib = config.costevolution_incentivebalance;

C(C<=0) = C(C<=0) .* ib;
C(C>0) = C(C>0) * (1-ib);

C2 = zeros(T,T);

for w=1:W
    
    d = diag( C, w );
    sg = sign(d);
  
    in = idiag(size(C), w);
    
    C2( in((diffn+1):end) ) = ...
        sg( diffn+1:end ) .* ...
        abs( diff( d, diffn ) );
end

C2 = normalize_costmatrix( C2 ) ...
    .* config.use_costcontigevolution;

end
