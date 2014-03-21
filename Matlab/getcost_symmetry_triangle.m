function [ SC ] = getcost_symmetry_triangle( SC, C, t, width, costsymmetry_incentivebalance )
% part of the dynamic programming implementation of getcost_symmetry

    num_dags = floor( (width+1)/2 );
    
    % for each diag
    for d=2:num_dags

        % no point doing both sides of the dag line (symmetric)
        diag_length = width-(d-1);
        
        C_line = diag( C, d-1 );
        C_line = C_line( t:(t+diag_length-1) );
        
        first_half = ceil((diag_length-(d-1))/2);
        
        % start from the middle, as these are relevant for all SCs
        % in the chain
        for i=first_half:-1:1

            p1 = C_line( i );
            p2 = C_line( diag_length-i );

            new_cost = 0;
            
            if( p1 < 0 && p2 < 0 )

                mix = abs(p1+p2)/2;
                new_cost = (mix );
                new_cost = new_cost * costsymmetry_incentivebalance;
                new_cost = +new_cost;

            elseif( p1 > 0 && p2 > 0 )

                mix = abs(p1+p2)/2;
                new_cost = (mix );
                new_cost = new_cost * (1-costsymmetry_incentivebalance);
                new_cost = -new_cost;
            end 
            
            % update the relevant cost entries
            middle_distance = first_half-i+1;

            new_width = (middle_distance*2)-1;
            
            if( mod(diag_length,2) == 0 )
            	new_width = new_width + 1;
            end

            if( new_width ) > 0

                time_ind = t+i;
                
                SC( time_ind, new_width ) = ...
                    ( SC( time_ind, new_width ) +(new_cost) );

            end
            
        
            
        end
    end

end

