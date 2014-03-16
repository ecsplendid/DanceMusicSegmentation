% config settings

minTrackLength = 180;
maxExpectedTrackWidth = 580;%370*2;  %% magicisland=380*2 others 350*2
bandwidth = 5;%Hz
lowPassFilter = 1400;%Hz
highPassFilter = 200;%Hz
gaussian_filterdegree = 2;
cosine_transformexponent = 1;

% 1, favor short tracks, 2 long tracks, 3 add gauss, 4 multiply gauss
costmatrix_normalizationtype = 0; 

costmatrix_parameter = 0.2;
costmatrix_regularization = 1;
eta = 10;
drawsimmat = 1;
draw_confs = 0;
solution_shift = 0;
usesymmetry = 1;