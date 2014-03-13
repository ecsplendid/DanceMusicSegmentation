function saveTightFigure(h,outfilename)
% get all axes
a = findall(h,'type','axes')

% remove axis corresponding to legends
legendIndex = zeros(length(a),1);
for i = 1:length(a)
if(strcmp(get(a(i),'Tag'),'legend'))
legendIndex(i) = 1;
end
end
a(legendIndex==1) = [];

% expand plot view
for i=1:length(a)
ti = get(a(i),'TightInset');
op = get(a(i),'OuterPosition');
set(a(i),'Position',[op(1)+ti(1) op(2)+ti(2) op(3)-ti(3)-ti(1) op(4)-ti(4)-ti(2)]);
end

% calculate papersize
set(a,'units','centimeters');
xpapermax =-inf; xpapermin=+inf;
ypapermax =-inf; ypapermin=+inf;
for i=1:length(a)
pos = get(a(i),'Position');
ti = get(a(i),'TightInset');
if( pos(1)+pos(3)+ti(1)+ti(3) > xpapermax); xpapermax = pos(1)+pos(3)+ti(1)+ti(3);end
if( pos(1) < xpapermin); xpapermin = pos(1);end
if( pos(2)+pos(4)+ti(2)+ti(4) > ypapermax); ypapermax = pos(2)+pos(4)+ti(2)+ti(4);end
if( pos(2) < ypapermin); ypapermin = pos(2);end
end
paperwidth = xpapermax - xpapermin;
paperhight = ypapermax - ypapermin;

% adjust the papersize
set(h, 'PaperUnits','centimeters');
set(h, 'PaperSize', [paperwidth paperhight]);
set(h, 'PaperPositionMode', 'manual');
set(h, 'PaperPosition',[0 0 paperwidth paperhight]);

saveas(h,outfilename);