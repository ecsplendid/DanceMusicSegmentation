function [shows] = get_allshows(config)

    if( config.dataset == 1 )
        shows = shows_githubtestset();
    else
        shows = shows_allshows();
    end
end