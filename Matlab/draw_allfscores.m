function draw_allfscores(ag)
%%

draw_fscores( ag.asot, 0 );
axis square
axis tight;
title('F_1 Scores (ASOT)')
exportfig(gcf,'figures/fasot.eps');

draw_fscores( ag.tatw, 0 );
axis square
title('F_1 Scores (TATW)')
exportfig(gcf,'figures/tatw.eps');

draw_fscores( ag.magic, 0 );
axis square
title('F_1 Scores (MAGIC)')
exportfig(gcf,'figures/magic.eps');

draw_fscores( ag.lindmik, 0 );
axis square
title('F_1 Scores (LINDMIK)')
exportfig(gcf,'figures/lindmik.eps');

draw_fscores( ag, 0 );
axis square
title('F_1 Scores (ALL)')
exportfig(gcf,'figures/fall.eps');


end