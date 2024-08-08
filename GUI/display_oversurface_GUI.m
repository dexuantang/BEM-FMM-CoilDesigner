function [ ] = display_oversurface_GUI(parent, S, fun, caption)
    set(parent, 'Color', 'White');
    patch(parent, 'faces', S.t, 'vertices', S.P, 'FaceVertexCData', fun, 'FaceColor', 'flat', 'EdgeColor', 'none', 'FaceAlpha', 1.0);
    alpha = 11; beta = 31; 
    axis(parent, 'equal');
    axis(parent, 'tight'); 
    lightangle(parent, alpha, beta);
    lighting(parent, 'gouraud');
    title(parent, caption);
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    zlabel(parent,'Z (m)');
    set(parent,'fontsize',20)
    setAxes3DPanAndZoomStyle(zoom(parent),parent,'camera')
    view(parent, alpha, beta);
    colorbar(parent);
end
