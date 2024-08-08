function [P, t] = meshfill(x, y)
    %   Creates an inner mesh P, t for an arbitrarily oriented planar polygon
    %   x, y
    %     
    %   Copyright SNM/JGF-2022
    
    %   Select avg edge length as a mean distance between polygon nodes
    STEP = [x(2:end); y(2:end)] - [x(1:end-1); y(1:end-1)]; 
    STEP = vecnorm(STEP);
    STEP = mean(STEP);
    %   Create uniform grid covering the cross-section
    X = [min(x):STEP:max(x)];
    Y = [min(y):STEP:max(y)];
    P = zeros(length(X)*length(Y), 2); 
    k = 1;
    for m = 1:length(X)
        for n = 1:length(Y)
            P(k, :) = [X(m) Y(n)];
            k = k + 1;
        end
    end
    %   Keep nodes within the polygon
    [in, on]    = inpolygon(P(:, 1), P(:, 2), x, y);
    outside         = ~in;
    outside         = outside|on;
    P(outside, :)   = [];
    %   Remove nodes very close to the polygon nodes
    ind = [];
    for m = 1:size(P, 1)
        dist = sqrt((x-P(m, 1)).^2 + (y-P(m, 2)).^2);
        if min(dist)<STEP/4
            ind = [ind m];
        end
    end
    P(ind, :) = [];
    %   Add boundary nodes up front
    P = [[x' y']; P];
    %   Do 2D Delaunay
    dt      = delaunayTriangulation(P);  %   2D Delaunay
    t       = dt.ConnectivityList;
    C       = meshtricenter(P, t);
    %   Keep facets within the polygon only (for non-convex objects) 
    in          = inpolygon(C(:, 1), C(:, 2), x, y);
    t(~in, :)   = [];
    %   Do Laplacian smoothing on inner nodes
    alpha   = 0.5;
    nodes   = length(x)+1:(size(P, 1) - 4);
    for m = 1:3
        P       = meshlaplace(P, t, nodes, alpha);
    end
    %   Fix mesh
    P(:, 3)     = 0;
    [P, t]      = fixmesh(P, t);
end
    