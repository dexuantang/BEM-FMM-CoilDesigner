function [ ] = display_wiremodel(strcoil)
    %   Display wire-based model
    figure; set(gcf,'Color','White');
    patch('faces', strcoil.Ewire, 'vertices', strcoil.Pwire, 'EdgeColor', 'b', 'FaceColor', [1 0 0], 'LineWidth', 0.5);
    alpha = 11; beta = 31;
    view(alpha, beta)
    axis equal; axis tight;
end