function [ score ] = get_contigscore( p1, p2, width_progression, ...
    width, costcontig_incentivebalance, gwin )
%get_contigcost get the contig cost for a pair of cells

    mix = (abs(p1)+abs(p2))/2;

    score = (mix);
    % contiguity more important in the center 
    % of the expected track size
    score = score * gwin(width);
    % contiguity more important the further away it is
    score = score / width_progression;

    if( max(p1, p2) < 0)
       score = score * costcontig_incentivebalance;
       score = -score;
    end

    if(  min(p1,p2) > 0 )
        score = score * (1-costcontig_incentivebalance);
        score =  +score;

    end

end

