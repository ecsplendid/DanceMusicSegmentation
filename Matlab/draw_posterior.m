function draw_posterior( show, dataset, figname )
% imagesc a posterior (for the paper)

s=execute_show(show,config_getbest(dataset,1));
figure(8);
imagesc(log(s.posterior));
title(sprintf('Log-Posterior for %s', s.show.showname) );
xlabel('Tiles');
ylabel('Track');
axis xy;
grid on;
axis square;
axis tight;
colorbar;

l = load('colormaps/posterior.mat');

colormap(l.map);

if ~isempty(figname)
    exportfig( gcf, sprintf( 'figures/%s.eps', figname ));
end

end