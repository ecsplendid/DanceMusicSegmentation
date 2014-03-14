function [SC] = heuristicscale_costmatrix ( ...
    costmatrix_normalizationtype, ...
    costmatrix_parameter, SC, W )

    SC = normalize_costmatrix( SC );

    % 1, favor short tracks
    if( costmatrix_normalizationtype == 1) 

        SC = SC .* repmat( (W:-1:1).^costmatrix_parameter, size(SC,1), 1);
    end
    
    % 2 favor long tracks exponentially, if costmatrix_parameter==1, 
    % will normalize on track length
    if( costmatrix_normalizationtype == 2) 

        SC = SC .* repmat( (1:W).^costmatrix_parameter, size(SC,1), 1);  
    end
    %3 fit gaussian
    if( costmatrix_normalizationtype == 3) 

        window_matrix_gauss = ...
            repmat( (( 1- (gausswin(W).* costmatrix_parameter) ))',...
            size(SC,1), 1  );

        %%
        
     
        
        %%1- (gausswin(W).* costmatrix_parameter)
        
        %SC = (SC + 1) - window_matrix_gauss;
        % rather than adding, which is independent of our costs
        % lets try multiplying again
        
        SC = SC.* window_matrix_gauss;
        
    end
    
    SC = normalize_costmatrix( SC );

end