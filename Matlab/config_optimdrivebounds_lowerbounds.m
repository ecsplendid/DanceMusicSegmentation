function [rs] = config_optimdrivebounds_lowerbounds()

    rs = nan(1,22);

    % 1: sumIB /in [0,1]
    rs(1) = 0;
    % 2: sum_contribution /in [0,2]
    rs(2) = 0;
    % 3: symIB /in [0,1]
    rs(3) = 0;
    % 4: sym contr /in [0,2]
    rs(4) = 0;
    % 5: evolution IB /in [0,1]
    rs(5) = 0;
    % 6: evolution contr /in [0,2]
    rs(6) = 0;
    % 7: contigpast IB /in [0,1]
    rs(7) = 0;
    % 8: contigpast contr /in [0,2]
    rs(8) = 0;
    % 9: contigfut IB /in [0,1]
    rs(9) = 0;
    % 10: contigfut contr /in [0,2]
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
    % 17: maxExpectedTrackWidth /in {8*60,...,15*60}
    rs(17) = 8*60;
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