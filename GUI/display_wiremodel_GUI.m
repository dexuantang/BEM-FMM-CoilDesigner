function [ ] = display_wiremodel_GUI(parent, strcoil)
    %   Display wire-based model
    set(parent,'Color','White');
    patch(parent,'faces', strcoil.Ewire, 'vertices', strcoil.Pwire, 'EdgeColor', 'b', 'FaceColor', [1 0 0], 'LineWidth', 0.5);
    alpha = 11; beta = 31;
    view(parent, alpha, beta)
    axis(parent, 'equal');
    axis(parent, 'tight'); 
    set(parent,'fontsize',20)
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    zlabel(parent,'Z (m)');
end