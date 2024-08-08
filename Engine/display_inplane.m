function [ ] = display_inplane(points, fun, caption)
    %   Display fields in plane   
    figure; set(gcf,'Color','White');
    dt      = delaunayTriangulation(points(:, 1), points(:, 2));
    tri     = dt.ConnectivityList ;
    F       = scatteredInterpolant(points(:, 1), points(:, 2), fun);
    trisurf(tri, points(:, 1), points(:, 2), F(points(:, 1), points(:, 2)));
    view(-38, 24); shading interp; colorbar;
    title(caption);
end