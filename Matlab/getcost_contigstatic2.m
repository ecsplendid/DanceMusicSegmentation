function [SC] = getcost_contigstatic2(...
    show, config ) 
 %getcost_contigstatic2 180914
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
W = show.W;
C = show.CosineMatrix;
ibp = config.costcontigpast_incentivebalance;
ibf = config.costcontigfuture_incentivebalance;

if config.use_costcontigfuture <= 1e-6 ...
        && config.use_costcontigpast <= 1e-6
    SC = zeros(T, W);
    
    return;
end


CP = C;
CP(CP<=0) = CP(CP<=0) .* ibp;
CP(CP>0) = CP(CP>0) * (1-ibp);
CP = CP * config.use_costcontigpast;

CF = C;
CF(CF<=0) = CF(CF<=0) .* ibf;
CF(CF>0) = CF(CF>0) * (1-ibf);
CF = CF * config.use_costcontigfuture;

sg = sign(C);

dpa = config.costcontig_pastdiffwindow;
dfa = config.costcontig_futurediffwindow;

Cpast = ( (flipud((diff(flipud(CP), dpa)))')' );
Cfuture = diff(CF,dfa,2)'; 

C3 = ones(T,T);

C3( dpa+1:T, : ) = Cpast;
C3( dfa+1:T, : ) = C3( dfa+1:T, : ) + Cfuture;

C3 = sg .* ( abs(C3)  );

show.CosineMatrix = C3;

SC = getcost_sum( show, config, 1, 0.5, ...
        config.costcontig_normalization );

SC(:,1:show.w-1 )=inf;

%%

end