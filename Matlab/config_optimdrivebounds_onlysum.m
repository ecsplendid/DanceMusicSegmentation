function [rs] = config_optimdrivebounds_onlysum( upper, gauss )
  
rs = nan(1,25);

    if( upper )
    
        % 1: sumIB /in [0,1]
        rs(1) = 1;
        % 2: sum_contribution /in [0,1]
        rs(2) = 1;
        % 3: symIB /in [0,1]
        rs(3) = 0;
        % 4: sym contr /in [0,1]
        rs(4) = 0;
        % 5: evolution IB /in [0,1]
        rs(5) = 0;
        % 6: evolution contr /in [0,1]
        rs(6) = 0;
        % 7: contigpast IB /in [0,1]
        rs(7) = 0;
        % 8: contigpast contr /in [0,1]
        rs(8) = 0;
        % 9: contigfut IB /in [0,1]
        rs(9) = 0;
        % 10: contigfut contr /in [0,1]
        rs(10) = 0;
        % 11: gauss IB /in [0,1]
        rs(11) = gauss;
        % 12: gauss cont /in [0,1]
        rs(12) = gauss;
        % 13: cosine norm /in [0.4,1.4]
        rs(13) = 1.4;
        % 14: solution_shift /in {-3,-2,-1,0,1,2,3}
        rs(14) = 3;
        % 15: minTrackLength /in {80,121,...,180}
        rs(15) = 180;
        % 16: maxExpectedTrackWidth /in {10*60,...,15*60}
        rs(16) = 15*60;
        % 17: bandwidth /in {1,2,...,15}
        rs(17) = 15;
        % 18: lowPassFilter /in {800,...,1950}
        rs(18) = 1950;
        % 19: highPassFilter /in {50,...,500}
        rs(19) = 500;
        % 20: secondsPerTile /in {5,6,...,20}
        rs(20) = 20;
        % 21: contig penalty /in {0.05,...,5}
        rs(21) = 5;
        % 22: costevolution_normalization /in {0.1,...,3}
        rs(22) = 0;
        % 23: costsum_normalization /in {0.1,...,3}
        rs(23) = 5;
        % 24: costcontig_normalization /in {0.1,...,3}
        rs(24) = 0;
        % 25: costsym_normalization /in {0.1,...,3}
        rs(25) = 0;
    
    else
        
        % 1: sumIB /in [0,1]
        rs(1) = 0;
        % 2: sum_contribution /in [0,1]
        rs(2) = 0;
        % 3: symIB /in [0,1]
        rs(3) = 0;
        % 4: sym contr /in [0,1]
        rs(4) = 0;
        % 5: evolution IB /in [0,1]
        rs(5) = 0;
        % 6: evolution contr /in [0,1]
        rs(6) = 0;
        % 7: contigpast IB /in [0,1]
        rs(7) = 0;
        % 8: contigpast contr /in [0,1]
        rs(8) = 0;
        % 9: contigfut IB /in [0,1]
        rs(9) = 0;
        % 10: contigfut contr /in [0,1]
        rs(10) = 0;
        % 11: gauss IB /in [0,1]
        rs(11) = 0;
        % 12: gauss cont /in [0,1]
        rs(12) = 0;
        % 13: cosine norm /in [0.4,1.4]
        rs(13) = 0.4;
        % 14: solution_shift /in {-3,-2,-1,0,1,2,3}
        rs(14) = -3;
        % 15: minTrackLength /in {80,121,...,180}
        rs(15) = 80;
        % 16: maxExpectedTrackWidth /in {10*60,...,15*60}
        rs(16) = 10*60;
        % 17: bandwidth /in {1,2,...,15}
        rs(17) = 1;
        % 18: lowPassFilter /in {800,...,1950}
        rs(18) = 800;
        % 19: highPassFilter /in {50,...,500}
        rs(19) = 50;
        % 20: secondsPerTile /in {5,6,...,20}
        rs(20) = 3;
        % 21: contig penalty /in {0.05,...,5}
        rs(21) = 0.05;
        % 22: costevolution_normalization /in {0.01,...,3}
        rs(22) = 0;
        % 23: costsum_normalization /in {0.01,...,3}
        rs(23) = 0.1;
        % 24: costcontig_normalization /in {0.01,...,3}
        rs(24) = 0;
        % 25: costsym_normalization /in {0.01,...,3}
        rs(25) = 0;
    end
end