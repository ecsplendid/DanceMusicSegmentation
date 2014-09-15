function [shows] = get_physicalshows(config)
%get_physicalshows get the actual shows with some heuristic
% for allocating some to GPU. I have noticed that the machine
% dies if you bombard too many to GPU, perhaps more than 2 at a time

    shows = get_allshows(config);
    
    for s=1:length(shows)
       shows{s}.use_gpu = 0;
       shows{s} = get_show(s, config); 
    end
end