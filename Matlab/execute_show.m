function [ results ] = ...
    execute_show( show, config, ...
    track_config, novelty_config )

    if( nargin < 2 )
        config = config_getdefault;
    end
    
    if( nargin < 3 )
        track_config = [];
    end    
    
    if( nargin < 4 )
        novelty_config = track_config;
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
    
    if ~isempty( novelty_config )
    
        novelty_config.dataset = config.dataset;
        
        nshow = get_show(show.number, novelty_config); 
        nshow = get_cosinematrix( nshow, novelty_config );
        
        % novelty predictions
        results.predictions_novelty = ...
            get_noveltyfunction( ...
                nshow, novelty_config, ...
                config.drawSimMat );
        
        % novelty track error
        results.trackestimate_noveltyerror = ...
            (length( nshow.indexes ) + 1) ...
            - (length( results.predictions_novelty ) + 1);
        
        % novelty predictions w/tracks known
        results.predictions_noveltytracksknown = ...
            get_noveltyfunction( ...
                nshow, novelty_config, ...
                1, length(nshow.indexes) );
    end
    
    % naive track estimate
    results.trackestimate_naive = ...
        round(show.showlength_secs / ...
            config.trackestimate_naiveaverage);
    results.trackestimate_naiveerror = ...
         results.trackestimate_naive - (length(show.indexes)+1);
     
    % predict track number using our method
    if ~isempty( track_config )
       
        track_config.dataset = config.dataset;
        
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
