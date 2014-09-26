function stats_shows
%%
    config = config_getbest(2);
    shows = get_allshows(config);

    sums = zeros(5,1);
    
    for i=1:length(shows)
       
        sums( show_getindex( shows{i}.file ), 1 ) ...
         = sums( show_getindex( shows{i}.file ), 1 ) + 1;
        
    end
    
    sums

end