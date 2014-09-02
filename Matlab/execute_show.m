function [ results, show ] = ...
    execute_show( s, config )

if( nargin < 2 )
    config = config_getdefault;
end

% execute a given show, read the file, extract the features,
% generate the cosine (similarity) matrix, generate the cost
% matrices, add them together, (all with a given config) 
% and evaluate performance, and return that
% hint: try running me with execute_show(3, config_getdefault)
% s is show number, there are 6 in the github test set

    results = show_results();

    show = get_show(s, config);
    
    show = get_cosinematrix( show, config );
    
    clear show.audio;
        
    CN = getcost_sum3( show, config ...
            ) .* config.use_costsum;  
        
    CS = getcost_symmetry3( show, config ...
        ) .* config.use_costsymmetry;  
    
    CDG = getcost_contigdiag1( show, config ...
        ) .* config.use_costcontigevolution;  

    future = 1;
    past = 0;
    
    SCS = getcost_contigstatic( ...
        show, config, past ... 
        ) .* config.use_costcontigpast;  
    
    SCSF = getcost_contigstatic( ...
        show, config, future ...
        ) .* config.use_costcontigfuture; 
    
    SCG = getcost_gaussian( show, config ) ...
        .* config.use_costgaussian;
    
    show.CostMatrix = CN+CS+CDG+SCS+SCSF+SCG;
    
    results = compute_trackplacement( config, show, results );
    results = estimate_numbertracks( show, results, config );
    
    if( config.compute_confs )
        
        output_width = 200;
        
        results = ...
            find_posterior( show, config, output_width, results );

    end
         
end
