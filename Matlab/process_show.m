function [show] = process_show( show, config )
%process_show load the show, get cosine matrix, calculate cost matrices

% can pass in a show index and we load it, or just the show
% itself which will save time loading it
    if isnumeric( show ) 
       show = get_show(show, config); 
    end

% execute a given show, read the file, extract the features,
% generate the cosine (similarity) matrix, generate the cost
% matrices, add them together, (all with a given config) 
% and evaluate performance, and return that

    show = get_cosinematrix( show, config );
    
    show.audio = nan;

    % sum-based matrices (basic, contig future, past, evolution)
	CN = getcost_sum( ...
         show, config );
    
    % symmetry cost matrix
    CS = getcost_symmetry3( ...
        show, config );
    
    % gaussian regularisation cost matrix
    SCG = getcost_gaussian( ...
        show, config );
    
    show.CostMatrix = CS+CN+SCG;

end