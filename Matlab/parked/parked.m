
 diffmap_transient = 0.2;
        amount_diffmap = 0;
        amount_negdiffmap = 0;
        amount_posdiffmap = 0;
        amount_noplacemap = 0;
        amount_contiguity = 0;
        amount_allscale = 1;
        selfsim_disincentivefactor = 1;
        sc_scalefactor = 0;
        use_contiguity = 1;
        contig_thresh = 0.6;
        contiguity_parameter = 1e-1;
        contiguity_gaussscale = 1;
        noplace_thresh = 0.8;
        noplace_exponent = 2;

ms = max( SC( 1:end-W,end ) );SC = SC./ms;
ms = max( SC( 1:end-W,end ) );SC = SC./ms;

if( use_contiguity > 0 )

    self_similarity = get_selfsimilaritymatrix(T,W,C);

    selfsim_indexdisincentive = ...
        get_selfsimilaritydisincentive(T,W,self_similarity);

   % noplace_map = 1-noplace_map;
    noplace_map(:,1:w )=0;
    
    for t=1:T
        noplace_map( t,: ) = noplace_map( t,: ) .* ( (1:W) .^ noplace_exponent );
    end
    
	noplace_map = (noplace_map ./ max(max(noplace_map)));
    noplace_map = 1-noplace_map;


    sc_inf = isinf(SC);
    
    %prenormalize 
    ms = max( SC( 1:end-W,end ) );
    SC = SC./ms;
    
    new_map = zeros( T, W);
    
    if amount_noplacemap > 0
        
        new_map = new_map +(1-(noplace_map.*amount_noplacemap)); 
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