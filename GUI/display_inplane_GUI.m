function [ ] = display_inplane_GUI(parent, points, fun, caption)
    %   Display fields in plane   
    set(parent,'Color','White');
    dt      = delaunayTriangulation(points(:, 1), points(:, 2));
    tri     = dt.ConnectivityList ;
    F       = scatteredInterpolant(points(:, 1), points(:, 2), fun);
    trisurf(tri, points(:, 1), points(:, 2), F(points(:, 1), points(:, 2)), 'Parent', parent);
    view(parent, -38, 24)
    shading(parent, 'interp');
    colorbar(parent);
    title(parent, caption);
    set(parent,'fontsize',20)
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    zlabel(parent,'Z (m)');
end