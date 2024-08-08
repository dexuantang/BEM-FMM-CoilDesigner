function L = curvatureflowlaplace(TR)
% Function to compute curvature-flow Laplacian represented by a sparse
% matrix
% Input:
%   TR - Triangular object
% Output:
%   L - Laplace operator in diagonal sparce matrix form
%   
% Equation (1) from:
% Oscar Kin-Chung Au, Chiew-Lan Tai, Hung-Kuo Chu, Daniel Cohen-Or, 
% and Tong-Yee Lee. 2008. Skeleton extraction by mesh contraction. 
% ACM Trans. Graph. 27, 3 (August 2008), 1–10. 
% https://doi.org/10.1145/1360612.1360643

    P = TR.Points;
    t = TR.ConnectivityList;
    numVertices = size(P, 1);
    
    I = []; J = []; S = []; % For sparse matrix construction
    
    % Loop through each triangle to compute angles and cotangent weights
    for n = 1:size(t, 1)
        % Get the vertex indices of the triangle
        tri = t(n, :);
        
        % Coordinates of the vertices
        v1 = P(tri(1), :);
        v2 = P(tri(2), :);
        v3 = P(tri(3), :);
        
        % Compute edge vectors
        e1 = v2 - v1;
        e2 = v3 - v1;
        e3 = v3 - v2;
        
        % Compute the lengths of edges
        len_e1 = norm(e1);
        len_e2 = norm(e2);
        len_e3 = norm(e3);
        
        % Calculate all angles in the triangle using the dot product and norms
        alpha1 = acos(dot(-e1, e2) / (len_e1 * len_e2));
        alpha2 = acos(dot(e1, e3) / (len_e1 * len_e3));
        alpha3 = acos(dot(-e2, e3) / (len_e2 * len_e3));
        
        % Cotangent weights
        cot_alpha1 = cot(alpha1);
        cot_alpha2 = cot(alpha2);
        cot_alpha3 = cot(alpha3);
        
        % Add entries to the lists for constructing the Laplacian matrix
        % Off-Diagonal Entries:
        %   Line 1 in equation 1 in the paper
        %   tri(1), tri(2), tri(1), tri(3) represent the vertices connected by edges (i,j)(i,j), (i,k)(i,k)
        %   Each pair (i,j)(i,j) and (j,i)(j,i) are added twice (once for (i,j)(i,j) and once for (j,i)(j,i)) to ensure symmetry.
        %   S stores the cotangent weights corresponding to each edge.
        I = [I; tri(1); tri(2); tri(1); tri(3); tri(2); tri(3)];
        J = [J; tri(2); tri(1); tri(3); tri(1); tri(3); tri(2)];
        S = [S; cot_alpha3; cot_alpha3; cot_alpha2; cot_alpha2; cot_alpha1; cot_alpha1];
        
        % Diagonal entries:
        %   tri(1), tri(2), tri(3) represent the vertices of the triangle.
        %   Line 2 in equation 1 in the paper
        I_diag = [tri(1); tri(2); tri(3)];
        J_diag = [tri(1); tri(2); tri(3)];
        S_diag = [-cot_alpha3 - cot_alpha2; -cot_alpha3 - cot_alpha1; -cot_alpha2 - cot_alpha1];
        
        I = [I; I_diag];
        J = [J; J_diag];
        S = [S; S_diag];
    end
    
    % Create the sparse Laplacian matrix
    L = sparse(I, J, S, numVertices, numVertices);

end
