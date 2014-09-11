function [ results ] = ...
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

    tic;
    
    results = show_results();

    show = get_show(s, config);
    
    show = get_cosinematrix( show, config );
    
    show.audio = nan;
        
    CN = getcost_sum( show, config, ...
        config.use_costsum, config.costsum_incentivebalance  ); 
    
    CS = getcost_symmetry3( show, config );  
    CDG = getcost_contigdiag1( show, config );  
    SCS = getcost_contigstatic2( show, config );  
    SCG = getcost_gaussian( show, config );
    
    show.CostMatrix = CN+CS+CDG+SCS+SCG;
    
    results = compute_trackplacement( config, show, results );
    results = estimate_numbertracks( show, results, config );
    
    if( config.compute_confs )
        
        output_width = 200;
        
        results = ...
            find_posterior( show, config, output_width, results );

    end
    
    results.config = config;
    results.show = show;
    results.execution_time = toc;
    
    if config.drawSimMat == 1 
       
        results.vis();
    end
    
    if config.memory_efficient == 1
        
        results.show.CosineMatrix=nan;
        results.show.CostMatrix=nan;
    end
         
end
