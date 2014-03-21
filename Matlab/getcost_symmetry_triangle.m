function [ SC ] = getcost_symmetry_triangle( SC, dags, t, width, costsymmetry_incentivebalance )
% part of the dynamic programming implementation of getcost_symmetry

    num_dags = floor( (width+1)/2 );
    
    is_even = mod(width,2) == 0;
    
    costsymmetry_incentivebalance = 1;
    
    costs = zeros( num_dags, 1 );
    
    % for each diag
    for d=2:width

        % no point doing both sides of the dag line (symmetric)
        diag_length = width-(d-1);
        
        C_line = dags(d, 1:diag_length);
        
        first_half = ceil(diag_length/2);
        
        % start from the middle, as these are relevant for all SCs
        % in the chain
        for i=first_half:-1:1

            % update the relevant cost entries
            travel = first_half-i+1;
            
            p1 = C_line( i );
            p2 = C_line( end-(i-1) );
           
            if( p1 < 0 && p2 < 0 )

                mix = abs(p1+p2)/2;
                new_cost = (mix );
                new_cost = new_cost * costsymmetry_incentivebalance;
                new_cost = -new_cost;
                
                costs( min(d-1,travel):end ) = costs( min(d-1,travel):end ) + new_cost;
                
            elseif( p1 > 0 && p2 > 0 )

                mix = abs(p1+p2)/2;
                new_cost = (mix );
                new_cost = new_cost * (1-costsymmetry_incentivebalance);
        
                costs( min(d-1,travel):end ) = costs( min(d-1,travel):end ) + new_cost;
                
            end 
            
        end
        
    end
    
    % insert the costs into the matrix
    for c=1:num_dags
        
        SC( t+num_dags-c, ((c*2)-1)+is_even ) = costs(c)/num_dags;
        
    end
end

