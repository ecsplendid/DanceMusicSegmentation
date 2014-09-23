function [shows] = get_allshows(config)

    if( config.dataset == 1 )
        shows = shows_githubtestset();
    elseif config.dataset == 2
        shows = shows_allshows();
    elseif config.dataset == 3
        shows = shows_lindmik();
    end
end