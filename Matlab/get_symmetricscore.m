function [ score ] = get_symmetricscore( min_w, p1, p2, w, costsymmetry_incentivebalance )
%get_symmetricscore get the symmetric score
% of two points

    mix = (abs(p1) + abs(p2))/2;

    score = 0;
    
    if( p1 < 0 && p2 < 0 )

        score = (mix / w);
        score = score * costsymmetry_incentivebalance;

        score = -score;
    end 

    if( p1 > min_w && p1 > 0 && p2 > 0 )

        score = (mix / w);
        score = score * (1-costsymmetry_incentivebalance);

        score = +score;

    end 

end

