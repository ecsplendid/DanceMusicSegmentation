function [shows] = get_allshows()

    cd dataset;
    % shows = shows_allshows();
    shows = shows_githubtestset();
    cd ..;
end