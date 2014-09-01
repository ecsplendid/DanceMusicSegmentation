function [rs] = config_optimdrivebounds_randomstart()

    rs = nan(1,21);

    % 1: sumIB /in [0,1]
    rs(1) = rand;
    % 2: sum_contribution /in [0,2]
    rs(2) = rand*2;
    % 3: symIB /in [0,1]
    rs(3) = rand;
    % 4: sym contr /in [0,2]
    rs(4) = rand*2;
    % 5: evolution IB /in [0,1]
    rs(5) = rand;
    % 6: evolution contr /in [0,2]
    rs(6) = rand*2;
    % 7: contigpast IB /in [0,1]
    rs(7) = rand;
    % 8: contigpast contr /in [0,2]
    rs(8) = rand*2;
    % 9: contigfut IB /in [0,1]
    rs(9) = rand;
    % 10: contigfut contr /in [0,2]
    rs(10) = rand*2;
    % 11: gauss IB /in [0,1]
    rs(11) = rand;
    % 12: gauss cont /in [0,2]
    rs(12) = rand*2;
    % 13: cosine norm /in [0.4,1.4]
    rs(13) = rand+0.4;
    % 14: contig window /in {1,2,...,5}
    rs(14) = ceil(rand * 5);
    % 15: solution_shift /in {-3,-2,-1,0,1,2,3}
    rs(15) = ceil(rand * 6)-3;
    % 16: minTrackLength /in {120,121,...,220}
    rs(16) = ceil(rand * (180-80))+80;
    % 17: maxExpectedTrackWidth /in {8*60,...,15*60}
    rs(17) = ceil(rand * ((15*60)-(8*60)))+(8*60);
    % 18: bandwidth /in {1,2,...,15}
    rs(18) = ceil(rand * 16)+1;
    % 19: lowPassFilter /in {800,...,1950}
    rs(19) = ceil(rand * (1950-800))+800;
    % 20: highPassFilter /in {50,...,500}
    rs(20) = ceil(rand * (500-50))+50;
    % 21: gaussian_filterdegree /in {1,2}
    rs(21) = ceil(rand*2); 
    % 22: secondsPerTile /in {5,6,...,20}
    %rs(22) = ceil(rand * 15)+5;
end