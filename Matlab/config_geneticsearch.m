
options = gaoptimset;

options = gaoptimset(options,'PopulationSize', 50);
options = gaoptimset(options,'EliteCount', 10);
options = gaoptimset(options,'Generations', 20);
options = gaoptimset(options,'StallGenLimit', 5);
options = gaoptimset(options,'Display', 'iter');
options = gaoptimset(options,'PlotFcns', {  @gaplotbestf @gaplotbestindiv @gaplotdistance @gaplotexpectation @gaplotgenealogy @gaplotrange @gaplotscorediversity @gaplotscores @gaplotselection @gaplotstopping @gaplotmaxconstr });
options = gaoptimset(options,'Vectorized', 'off');
options = gaoptimset(options,'UseParallel', 1 );

x = ga( @optimise_function, ...
    21, ... % num constraints
    [],[],[],[], ...
    config_optimdrivebounds_lowerbounds, ...
    config_optimdrivebounds_upperbounds, ...
    [], ...
    [14,15,16,17,18,19,20,21], ... % int constraints
    options );