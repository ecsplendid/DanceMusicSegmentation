function [ results ] = ...
    execute_show( show, config, track_config )

    if( nargin < 2 )
        config = config_getdefault;
    end
    
    if( nargin < 3 )
        track_config = [];
    end    

    tic;

    show = process_show( show, config );
    
    results = show_results();

    results = compute_trackplacement( config, show, results );
    
    if config.estimate_tracks && isempty( track_config )
        results = estimate_numbertracks( show, results, config );
    end
    
    if( config.compute_confs )
        
        output_width = 200;
        
        results = ...
            find_posterior( show, config, output_width, results );
    end
    
    results.config = config;
    results.show = show;
    results.execution_time = toc;
    
    if config.drawSimMat == 1 
       
        results.vis(1);
    end
    
    % novelty predictions
    results.trackestimate_novelty = ...
        get_noveltyfunction( ...
            results, ...
            config.novelty_kernelsize, ...
            config.novelty_minpeakradius, ...
            config.novelty_threshold, ...
            config.drawSimMat );
        
    % novelty track error
    results.trackestimate_noveltyerror = ...
        (length( show.indexes ) + 1) ...
        - (length( results.trackestimate_novelty ) + 1);
    
    % naive track estimate
    results.trackestimate_naive = ...
        round(show.showlength_secs / ...
            config.trackestimate_naiveaverage);
    results.trackestimate_naiveerror = ...
         results.trackestimate_naive - (length(show.indexes)+1);
     
    % predict track number using our method
    if ~isempty( track_config )
       
        show2 = process_show( show.number, track_config );
        results = estimate_numbertracks( ...
            show2, results, track_config );
        
        results_fair = show_results();
        
        results_fair = ...
            compute_trackplacement( ...
                config, show, results_fair, ...
                results.track_estimate );
            
        results.predictions_tracksnotknown = ...
            results_fair;
    end
     
    if config.memory_efficient == 1
        
        results.show.CosineMatrix=nan;
        results.show.CostMatrix=nan;
    end
    

end
