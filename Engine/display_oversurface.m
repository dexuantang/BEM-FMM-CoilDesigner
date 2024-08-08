function [ ] = display_oversurface(S, fun, P, t, caption)
    figure; set(gcf,'Color','White');
    patch('faces', S.t, 'vertices', S.P, 'FaceVertexCData', fun, 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 1.0);
    p = patch('vertices', P, 'faces', t, 'EdgeColor', 'none', 'FaceColor', [1 0.75 0.65]);
    alpha = 11; beta = 31; view(alpha, beta)
    axis equal; axis tight; 
    lightangle(gca, alpha, beta);
    lighting gouraud; colormap jet; colorbar
    title(caption);
end