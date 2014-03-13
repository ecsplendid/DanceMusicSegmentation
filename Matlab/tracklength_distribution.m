
asot

cut_tracks = [];

d = [];
trackcount = [];

for i=1:length(tatw_shows)
   
    trackcount = [trackcount; length(tatw_shows{i}.indexes) ];
    d = [d; diff( tatw_shows{i}.indexes ) ];
    
    if length(tatw_shows{i}.indexes)>22
   
       cut_tracks = [cut_tracks i];
    end
    
end

cut_tracks

trackcountmagic=trackcount

%% track count figure

tracks = [trackcountmagic; trackcountasot; trackcounttatw ]



%%

myBins = linspace(15,30,15); % pick my own bin locations

% Hists will be the same size because we set the bin locations:
y1 = hist(trackcountmagic, myBins);   
y2 = hist(trackcountasot, myBins);
y3 = hist(trackcounttatw, myBins);

% plot the results:
figure(3);
hBar =bar(myBins, [y1;y2;y3]','stacked');
title('Mixed show track distribution');



P=findobj(gca,'type','patch');

C = [ 0.9 0.9 0.9; ...
    0.7 0.7 0.7; ...
    0.5 0.5 0.5 ];
    
set(hBar,{'FaceColor'},{C(1,:);C(2,:);C(3,:);});

legend('magic','asot','tatw')

xlabel('Number of Tracks');
ylabel('Number of Shows with this Number of Tracks')

ti = get(gca,'LooseInset')
set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
set(gca,'units','centimeters')
pos = get(gca,'Position');

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

saveTightFigure(gcf,'tracknumbers.pdf');

%%



%%

myBins = linspace(0,600,70); % pick my own bin locations

% Hists will be the same size because we set the bin locations:

y1 = hist(dmagic, myBins);   
y2 = hist(dasot, myBins);
y3 = hist(dtatw, myBins);

hBar =bar(myBins, [y1;y2;y3]','stacked');
set(hBar,{'FaceColor'},{C(1,:);C(2,:);C(3,:);});
set(hBar,{'EdgeColor'},{C(1,:);C(2,:);C(3,:);});

legend('magic','asot','tatw')

%The bump of short tracks less than 2 minutes are assumed to be spoken introductions and removed. The average track length with said introduction tracks removed is 5 minutes, 25 seconds.
title('Track length distribution for all three shows. ')
xlabel('Track length (Seconds)');
ylabel('Number of Tracks')

axis tight


ti = get(gca,'LooseInset')
set(gca,'Position',[ti(1) ti(2) 1-ti(3)-ti(1) 1-ti(4)-ti(2)]);
set(gca,'units','centimeters')
pos = get(gca,'Position');

set(gcf, 'PaperUnits','centimeters');
set(gcf, 'PaperSize', [pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition',[0 0 pos(3)+ti(1)+ti(3) pos(4)+ti(2)+ti(4)]);

%print -r1200 -dpdf tracklength.pdf

saveTightFigure(gcf,'tracklength.pdf');