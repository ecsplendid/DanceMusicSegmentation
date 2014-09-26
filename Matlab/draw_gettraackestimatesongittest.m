function draw_gettraackestimatesongittest
%%
hold off;

for s=1:1

c = config_getdefault;
c.drawSimMat=0;
segc=config_getdefaultsegcalculation;
segc.drawSimMat=1;
hold on;
execute_show( s, c,segc );

end

end