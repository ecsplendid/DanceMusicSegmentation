function [rs] = config_optimdrivebounds_randomstart()

    rs = nan(1,25);

    % 1: sumIB /in [0,1]
    rs(1) = rand;
    % 2: sum_contribution /in [0,1]
    rs(2) = rand;
    % 3: symIB /in [0,1]
    rs(3) = rand;
    % 4: sym contr /in [0,1]
    rs(4) = rand;
    % 5: evolution IB /in [0,1]
    rs(5) = rand;
    % 6: evolution contr /in [0,1]
    rs(6) = rand;
    % 7: contigpast IB /in [0,1]
    rs(7) = rand;
    % 8: contigpast contr /in [0,1]
    rs(8) = rand;
    % 9: contigfut IB /in [0,1]
    rs(9) = rand;
    % 10: contigfut contr /in [0,1]
    rs(10) = rand;
    % 11: gauss IB /in [0,1]
    rs(11) = rand;
    % 12: gauss cont /in [0,1]
    rs(12) = rand;
    % 13: cosine norm /in [0.4,1.4]
    rs(13) = rand+0.4;
    % 14: solution_shift /in {-3,-2,-1,0,1,2,3}
    rs(14) = ceil(rand * 6)-3;
    % 15: minTrackLength /in {120,121,...,220}
    rs(15) = ceil(rand * (180-80))+80;
    % 16: maxExpectedTrackWidth /in {10*60,...,15*60}
    rs(16) = ceil(rand * ((15*60)-(10*60)))+(10*60);
    % 17: bandwidth /in {1,2,...,15}
    rs(17) = ceil(rand * 16)+1;
    % 18: lowPassFilter /in {800,...,1950}
    rs(18) = ceil(rand * (1950-800))+800;
    % 19: highPassFilter /in {50,...,500}
    rs(19) = ceil(rand * (500-50))+50;
    % 20: secondsPerTile /in {5,6,...,20}
    rs(20) = ceil(rand * 15)+5;
    % 21: contig penalty /in {0.05,...,5}
    rs(21) = ((rand+0.05)*(5+0.05));
    % 22: costevolution_normalization /in {0.1,...,4}
    rs(22) = 0.1+((rand*4)-0.1);
    % 23: costsum_normalization /in {0.1,...,4}
    rs(23) = 0.1+((rand*4)-0.1);
    % 24: costcontig_normalization /in {0.1,...,4}
    rs(24) = 0.1+((rand*4)-0.1);
    % 25: costsym_normalization /in {0.1,...,4}
    rs(25) = 0.1+((rand*4)-0.1);
end