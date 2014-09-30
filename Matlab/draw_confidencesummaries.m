



meanall = agr.track_placementconfidence_sum;
meansum = agr3.track_placementconfidence_sum;

meanall = conv(meanall, hamming(7),'same');
meansum = conv(meansum, hamming(7),'same');

plot(meanall,'k:', 'LineWidth',3);
hold on;
plot(meansum,'k', 'LineWidth',3);
hold off;

title('Time Placement Relative Confidence');
xlabel('Show Progression (%)')
ylabel('Track Placement Confidence');

legend( ...
    'mean optimized mixture of cost matrices', ...
    'mean optimized sum cost matrix only');


set( gca, 'XTick', linspace( 0,length(meanall),10 ));
set( gca, 'XTickLabels', floor(linspace( 0,100,10 )) );



grid on;
axis square;