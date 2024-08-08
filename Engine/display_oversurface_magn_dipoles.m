function [ ] = display_oversurface_magn_dipoles(S, fun, caption, positions)
    figure; set(gcf,'Color','White');
    plot3(positions(:, 1), positions(:, 2), positions(:, 3), '.');
    patch('faces', S.t, 'vertices', S.P, 'FaceVertexCData', fun, 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 1.0); 
    alpha = 11; beta = 31; view(alpha, beta)
    axis equal; axis tight; 
    lightangle(gca, alpha, beta); 
    lighting gouraud; colormap jet; colorbar
    title(caption);
end