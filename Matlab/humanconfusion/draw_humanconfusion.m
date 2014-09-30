

err = dlmread('asoterror.txt');

r = -60:1:60;

h = histc( err(:,1), r );
h = resample_matrix( h', 1000 );
h = conv(h,hamming(10),'same');

plot( linspace(-60,60,1000), h, 'k', 'LineWidth',3);

%%
grid on;
axis square
title('cuenation.com -- Human Confusion on ASOT shows');
xlabel('Seconds');
ylabel('Track Instances')


%% how much % of total error are these 4 peaks? its about 5%

a = sum(err(:,1)>11 & err(:,1)<34)+sum(err(:,1)>-33 & err(:,1)<-8)
a/size( err,1 )

%%

exportfig(gcf,'figures/human_confusion.eps')