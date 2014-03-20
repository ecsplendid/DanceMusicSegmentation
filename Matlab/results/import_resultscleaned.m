%% generated results_cleaned from the visual studio project
%% called ResultsParser (included)

%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\tim_000\Google
%    Drive\PhD\DanceMusicSegmentation\Matlab\results\results_cleaned
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2014/03/20 03:48:45

%% Initialize variables.
filename = 'results_cleaned';
delimiter = '\t';

%% Format string for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: double (%f)
%	column6: double (%f)
%   column7: double (%f)
%	column8: double (%f)
%   column9: double (%f)
%	column10: double (%f)
%   column11: double (%f)
%	column12: double (%f)
%   column13: double (%f)
%	column14: double (%f)
%   column15: double (%f)
%	column16: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,  'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
mean_res = dataArray{:, 1};
heuristic = dataArray{:, 2};
time = dataArray{:, 3};
SY = dataArray{:, 4};
CO = dataArray{:, 5};
SU = dataArray{:, 6};
GA = dataArray{:, 7};
SYIB = dataArray{:, 8};
COIB = dataArray{:, 9};
SUIB = dataArray{:, 10};
GAIB = dataArray{:, 11};
bw = dataArray{:, 12};
lp = dataArray{:, 13};
hp = dataArray{:, 14};
ss = dataArray{:, 15};
sa = dataArray{:, 16};

overall = (mean_res+heuristic)/2;

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;

%%

[best, ix] = sort( overall );

% take the best 20 results

best_results = ix(1:100);

subplot(6,2, 1);
hist( mean_res(best_results),20 );
title( 'Mean Accuracy' )

subplot(6,2, 2);
hist( heuristic(best_results),20 );
title( 'Heuristic Accuracy' )

subplot(6,2, 3);
hist( hp(best_results),20 );
title( 'HPF' )

subplot(6,2, 4);
hist( lp(best_results),20 );
title( 'LPF' )

subplot(6,2, 5);
hist( CO(best_results),20 );
title( 'CONTIG' )

subplot(6,2, 6);
hist( SU(best_results),20 );
title( 'SUM' )

subplot(6,2, 7);
hist( SY(best_results),20 );
title( 'SYMMETRY' )

subplot(6,2, 8);
hist( GA(best_results),20 );
title( 'GAUSS' )

subplot(6,2, 9);
hist( SYIB(best_results),20 );
title( 'SYMMETRY INCENTIVE BIAS' )

subplot(6,2, 10);
hist( COIB(best_results),20 );
title( 'CONTIG INCENTIVE BIAS' )

subplot(6,2, 11);
hist( SUIB(best_results),20 );
title( 'SUM INCENTIVE BIAS' )

subplot(6,2, 12);
hist( GAIB(best_results),20 );
title( 'GAUSS INCENTIVE BIAS' )

subplot(6,2, 13);
hist( bw(best_results),20 );
title( 'BW' )
