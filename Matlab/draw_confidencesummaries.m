
meanall = agr.track_placementconfidence_sum./339;
meansum = agr3.track_placementconfidence_sum./339;


plot(meanall,'k', 'LineWidth',3);
hold on;
plot(meansum,'k:', 'LineWidth',3);
hold off;

title('Time Placement Confidence');
xlabel('Show Progression (%)')
ylabel('Track Placement Average Confidence');

legend( ...
    'mixture', ...
    'sum-only');

set( gca, 'XTick', linspace( 0,length(meanall),10 ));
set( gca, 'XTickLabels', floor(linspace( 0,100,10 )) );

grid on;
axis tight
axis square;

exportfig(gcf,'figures/timeplacementconfidence.eps');

%%

meanall = agr.track_indexconfidences_sum./339;
meansum = agr3.track_indexconfidences_sum./339;

plot(meanall,'k', 'LineWidth',3);
hold on;
plot(meansum,'k:', 'LineWidth',3);
hold off;
grid on;
axis tight
axis square;

set( gca, 'XTick', linspace( 0,length(meanall),10 ));
set( gca, 'XTickLabels', floor(linspace( 0,100,10 )) );

legend( ...
    'mixture', ...
    'sum-only');

title('Index Placement Confidence');
xlabel('Show Progression (%)')
ylabel('Index Placement Average Confidence');

exportfig(gcf,'figures/indexplacementconfidence.eps');

%%

errors = sum(abs(agr.residuals_ourmethod))./339;

mi = min(errors);

errors = resample_matrix( errors, 300 );
errors = conv( errors, gausswin(100),'same' );

plot(errors,'k', 'LineWidth',3)

hold on;
errors = sum(abs(agr3.residuals_ourmethod))./339;
ma = max(errors);
errors = resample_matrix( errors, 300 );
errors = conv( errors, gausswin(100),'same' );
plot(errors,'k:', 'LineWidth',3)
hold off;
grid on;
axis tight
axis square;

set( gca, 'XTick', linspace( 0,length(errors),10 ));
set( gca, 'XTickLabels', floor(linspace( 0,100,10 )) );

set( gca, 'YTick', linspace( 1,max(errors),10 ));
set( gca, 'YTickLabels', floor(linspace( 1,ma,10 )) );

legend( ...
    'mixture', ...
    'sum-only');

title('Average Residual Error Over Show Progress');
xlabel('Show Progression (%)')
ylabel('Average Residual Error (S)');

axis tight

exportfig(gcf,'figures/residualsagainstprogress.eps');