function [WL, WH] = initweights(TR)
% Function that initiates the weights for contraction
% Input:
%   TR - Triangular object
% Output:
%   WL - Contraction weights
%   WH - Attraction weights
%
% Section (4) from:
% Oscar Kin-Chung Au, Chiew-Lan Tai, Hung-Kuo Chu, Daniel Cohen-Or, 
% and Tong-Yee Lee. 2008. Skeleton extraction by mesh contraction. 
% ACM Trans. Graph. 27, 3 (August 2008), 1–10. 
% https://doi.org/10.1145/1360612.1360643
    P = TR.Points;
    t = TR.ConnectivityList;
    
    % Number of vertices
    numVertices = size(P, 1);
    
    % Calculate face areas to determine weights
    faceAreas = zeros(size(t, 1), 1);
    
    % Calculate face areas
    for n = 1:size(t, 1)
        % Get the vertices of the triangle
        tri = t(n, :);
        v1 = P(tri(1), :);
        v2 = P(tri(2), :);
        v3 = P(tri(3), :);
        
        % Compute the area of the triangle using the cross product
        area = 0.5 * norm(cross(v2 - v1, v3 - v1));
        faceAreas(n) = area;
    end
    
    % Calculate the average face area
    averageFaceArea = mean(faceAreas);
    
    % Set initial weights
    W_0 = 10^-3; % Small constant for contraction weight
    W_L = W_0 * sqrt(averageFaceArea) * ones(numVertices, 1); % Initial contraction weights vector
    W_H = ones(numVertices, 1); % Initial attraction weights vector
    
    % Convert weights to sparse diagonal matrices
    WL = spdiags(W_L, 0, numVertices, numVertices); % Contraction weights matrix
    WH = spdiags(W_H, 0, numVertices, numVertices); % Attraction weights matrix

end


