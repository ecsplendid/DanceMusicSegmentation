function [C] = getcosines_contigstatic( show, config ) 
 %getcosines_contigstatic 200914
 % re-hash of contigous cost matrix concept
 % now the idea is we modify the cosine matrix in-place, and sum over
 % we work on two conceptualizations, "past" and "future"
 % past means we trace downwards from main diag, future accross
 % * apply incentive balance and usage scaling
 % * do trace wise Nth order differences future (across) past (down)
 % * set sign back to the original sign
 % * sum as usual, will now effectively sum the amount of contiguity
 
%%

T = show.T;

if config.use_costcontigfuture <= 1e-6 ...
        || config.use_costcontigpast <= 1e-6
   C = zeros( T, T ); 
   return;
end

C = show.CosineMatrix;
ibp = config.costcontigpast_incentivebalance;
ibf = config.costcontigfuture_incentivebalance;

C(isnan(C)) = 0;
sg = sign(C);

CP = C;
CP(CP<=0) = CP(CP<=0) .* ibp;
CP(CP>0) = CP(CP>0) * (1-ibp);

CF = C;
CF(CF<=0) = CF(CF<=0) .* ibf;
CF(CF>0) = CF(CF>0) * (1-ibf);

dpa = config.costcontig_pastdiffwindow;
dfa = config.costcontig_futurediffwindow;

Cpast = diff(CP, dpa, 2);
Cpast = normalize_costmatrix( Cpast ) ...
    .* config.use_costcontigpast;

Cfuture = diff(CF,dfa,1);
Cfuture = normalize_costmatrix( Cfuture ) .* ...
    config.use_costcontigfuture; 

C = ones(T,T);

C( :, dpa+1:T ) = Cpast;
C( dfa+1:T, : ) = C( dfa+1:T, : ) + Cfuture;

% this slice didn't get doubled up, lets guess it
% this is basically negligable so don't fret about it :)
C( :, dpa+1:T ) = C( :, dpa+1:T )  .* 2;

C = sg .* ( abs(C)  );

C = normalize_costmatrix( C );

end