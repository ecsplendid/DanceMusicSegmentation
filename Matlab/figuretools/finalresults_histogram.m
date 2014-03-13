hist(averages,100)
xlim([-500 500])
set(get(gca,'child'),'FaceColor','k','EdgeColor','None');

title('Average track accuracy (Naive Algorithm)');
xlabel('Seconds')
ylabel('Number of tracks within tolerance bin')
axis square
 print -depsc2 naive_abs.eps


%%

hist(errors,500)
xlim([-500 500])
set(get(gca,'child'),'FaceColor','k','EdgeColor','None');
axis square
title('Average track accuracy (Dynamic Algorithm)');
xlabel('Seconds')
ylabel('Number of tracks within tolerance bin')

 print -depsc2 dynamic_abs.eps

%%

myBins = linspace(-400,400,500); % pick my own bin locations
global_precisions = nan(3,7);

% Hists will be the same size because we set the bin locations:
load magicislandfinal
global_precisions(1,:) = sum(precisions(11:end,:))./total_tracks_magic;
y1 = hist(errors, myBins);  
load asotfinal
global_precisions(2,:) = sum(precisions(11:end,:))./total_tracks_asot;
y2 = hist(errors, myBins);
load tatwfinalresults
global_precisions(3,:) = sum(precisions(11:end,:))./total_tracks_tatw;
y3 = hist(errors, myBins);


hBar =bar(myBins, [y1;y2;y3]','stacked');
title('Mixed show average absolute track accuracy histogram');
xlabel('Accuracy Tolerance in Seconds')
ylabel('Number of tracks within tolerance bin')

P=findobj(gca,'type','patch');

C = [ 0.8 0.8 0.8; ...
    0.5 0.5 0.5; ...
    0.2 0.2 0.2 ];
    
set(hBar,{'FaceColor'},{C(1,:);C(2,:);C(3,:);});
set(hBar,{'EdgeColor'},{C(1,:);C(2,:);C(3,:);});

legend('magic','asot','tatw')


% = get(gca,'LooseInset')
%set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
%set(gca,'units','centimeters')
%pos = get(gca,'Position');

%set(gcf, 'PaperUnits','centimeters');
%set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
%set(gcf, 'PaperPositionMode', 'manual');
%set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

%saveTightFigure(gcf,'results_hist.pdf');

print -depsc2 proper_results.eps -r300
%%

global_precisions = nan(3,7);

myBins = linspace(-400,400,500); % pick my own bin locations

all_avg = 0;

% Hists will be the same size because we set the bin locations:
load magic_naives
y1 = hist(averages, myBins);  
all_avg = [all_avg; averages];
global_precisions(1,:) = sum(precisions)./total_tracks;
load asot_naives
y2 = hist(averages, myBins);
all_avg = [all_avg; averages];
global_precisions(2,:) = sum(precisions)./total_tracks;
load tatw_naives
y3 = hist(averages, myBins);
all_avg = [all_avg; averages];
global_precisions(3,:) = sum(precisions)./total_tracks;

mean(abs(all_avg))

hBar =bar(myBins, [y1;y2;y3]','stacked');
title('Mixed show average absolute track accuracy histogram (Naive)');
xlabel('Accuracy Tolerance in Seconds')
ylabel('Number of tracks within tolerance bin')

P=findobj(gca,'type','patch');

C = [ 0.8 0.8 0.8; ...
    0.5 0.5 0.5; ...
    0.2 0.2 0.2 ];
    
set(hBar,{'FaceColor'},{C(1,:);C(2,:);C(3,:);});
set(hBar,{'EdgeColor'},{C(1,:);C(2,:);C(3,:);});

legend('magic','asot','tatw')


%ti = get(gca,'LooseInset')
%set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
%set(gca,'units','centimeters')
%pos = get(gca,'Position');

%set(gcf, 'PaperUnits','centimeters');
%set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
%set(gcf, 'PaperPositionMode', 'manual');
%set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

%saveTightFigure(gcf,'results_hist.pdf');

print -depsc2 naive_results.eps -r300