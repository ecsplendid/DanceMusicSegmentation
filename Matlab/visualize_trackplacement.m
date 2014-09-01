figure(1)

% in time space 
% imagesc(space,space, sim_mat_fft);daspect([1 1 1]);colorbar;colorbar;axis xy;
% imagesc(space,space, C);daspect([1 1 1]);colorbar;colorbar;axis xy;

% in tile space
 imagesc(C);daspect([1 1 1]);colorbar;colorbar;axis xy;
draw_rectangles( [predictions T .* tileWidthSecs], 'k' );

draw_indexes(space(end)./indexes_tilespace, indexes_tilespace);
title(sprintf('1-Cosine Matrix\n%s\nCosine Matrix Histogram (Cosine Normalization=%.1f, %d Tiles)',...
    showname,cosine_normalization, T));
xlabel('Tiles');
ylabel('Tiles');

