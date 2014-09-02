%% options setup

options = gaoptimset;

options = gaoptimset(options,'PopulationSize', 50);
options = gaoptimset(options,'EliteCount', 10);
options = gaoptimset(options,'Generations', 20);
options = gaoptimset(options,'StallGenLimit', 5);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv @gaplotdistance @gaplotexpectation @gaplotgenealogy @gaplotrange @gaplotscorediversity @gaplotscores @gaplotselection @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );


%% for estimating the number of segments

segs = ga( @optimise_tracknumberestimate, ...
    22, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21,22], ... % int constraints
    options );

savefig('optimise_tracknumberestimate.fig');

%% for finding best segmentation

x = ga( @optimise_trackplacement, ...
    22, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21,22], ... % int constraints
    options );

savefig('optimise_trackplacement.fig');