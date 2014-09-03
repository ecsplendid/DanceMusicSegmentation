function [rs] = config_optimdrivebounds_onlysum( upper )

    rs = nan(1,22);

    if( upper )
    
        % 1: sumIB /in [0,1]
        rs(1) = 1;
        % 2: sum_contribution <REMOVED>
        rs(2) = 2;
        % 3: symIB /in [0,2]
        rs(3) = 0;
        % 4: sym contr <REMOVED>
        rs(4) = 0;
        % 5: evolution IB <REMOVED>
        rs(5) = 0;
        % 6: evolution contr <REMOVED>
        rs(6) = 0;
        % 7: contigpast IB <REMOVED>
        rs(7) = 0;
        % 8: contigpast contr <REMOVED>
        rs(8) = 0;
        % 9: contigfut IB<REMOVED>
        rs(9) = 0;
        % 10: contigfut contr <REMOVED>
        rs(10) = 0;
        % 11: gauss IB /in [0,1]
        rs(11) = 1;
        % 12: gauss cont /in [0,2]
        rs(12) = 2;
        % 13: cosine norm /in [0.4,1.4]
        rs(13) = 1.4;
        % 14: contig window /in {1,2,...,5}
        rs(14) = 5;
        % 15: solution_shift /in {-3,-2,-1,0,1,2,3}
        rs(15) = 3;
        % 16: minTrackLength /in {80,121,...,180}
        rs(16) = 180;
        % 17: maxExpectedTrackWidth /in {10*60,...,15*60}
        rs(17) = 15*60;
        % 18: bandwidth /in {1,2,...,15}
        rs(18) = 15;
        % 19: lowPassFilter /in {800,...,1950}
        rs(19) = 1950;
        % 20: highPassFilter /in {50,...,500}
        rs(20) = 500;
        % 21: gaussian_filterdegree /in /in {1,2}
        rs(21) = 2; 
        % 22: secondsPerTile /in {5,6,...,20}
        rs(22) = 20;
    
    else
        
        % 1: sumIB /in [0,1]
        rs(1) = 0;
        % 2: sum_contribution /in [0,2]
        rs(2) = 0;
        % 3: symIB <REMOVED>
        rs(3) = 0;
        % 4: sym contr <REMOVED>
        rs(4) = 0;
        % 5: evolution IB <REMOVED>
        rs(5) = 0;
        % 6: evolution contr <REMOVED>
        rs(6) = 0;
        % 7: contigpast IB <REMOVED>
        rs(7) = 0;
        % 8: contigpast contr <REMOVED>
        rs(8) = 0;
        % 9: contigfut IB<REMOVED>
        rs(9) = 0;
        % 10: contigfut contr <REMOVED>
        rs(10) = 0;
        % 11: gauss IB /in [0,1]
        rs(11) = 0;
        % 12: gauss cont /in [0,2]
        rs(12) = 0;
        % 13: cosine norm /in [0.4,1.4]
        rs(13) = 0.4;
        % 14: contig window /in {1,2,...,5}
        rs(14) = 1;
        % 15: solution_shift /in {-3,-2,-1,0,1,2,3}
        rs(15) = -3;
        % 16: minTrackLength /in {80,121,...,180}
        rs(16) = 80;
        % 17: maxExpectedTrackWidth /in {10*60,...,15*60}
        rs(17) = 10*60;
        % 18: bandwidth /in {1,2,...,15}
        rs(18) = 1;
        % 19: lowPassFilter /in {800,...,1950}
        rs(19) = 800;
        % 20: highPassFilter /in {50,...,500}
        rs(20) = 50;
        % 21: gaussian_filterdegree /in /in {1,2}
        rs(21) = 1; 
        % 22: secondsPerTile /in {5,6,...,20}
        rs(22) = 5;
    end
end