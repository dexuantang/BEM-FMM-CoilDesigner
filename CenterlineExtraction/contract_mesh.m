function Pcenter = contract_mesh(TR, L, WL, WH, max_iterations, sL)
% Function that contracts the mesh
% Input:
%   TR - Triangular object
%   L - curvature-flow Laplacian
%   WL - Contraction weights
%   WH - Attraction weights
%   max_iterations - Maximum number of iterations to contract the mesh
%   sL - Growth factor of WL
% Output:
%   Pcenter - Centerline points (contracted mesh points) 
%
% Section (4) from:
% Oscar Kin-Chung Au, Chiew-Lan Tai, Hung-Kuo Chu, Daniel Cohen-Or, 
% and Tong-Yee Lee. 2008. Skeleton extraction by mesh contraction. 
% ACM Trans. Graph. 27, 3 (August 2008), 1–10. 
% https://doi.org/10.1145/1360612.1360643
%   With modified attraction weights update.
    % Extract initial vertices
    P = TR.Points;
    numVertices = size(P, 1);
    
    % Set parameters for iterative contraction
    if isempty(max_iterations)
        max_iterations = 11;
    end
    if isempty(sL)
        sL = 8.0; % Growth factor for WL update
    end
    epsilon_vol = 1e-5; % Volume threshold for convergence

    % Initialize V' (contracted vertices) with original vertices
    Pcenter = P;
    %previous_Pcenter = Pcenter;

    % Initial volume of the mesh
    initial_volume = volume_of_mesh(TR);
    f = waitbar(0,'1','Name','Contracting Mesh...');
    
    for iter = 1:max_iterations
        % Solve the system [WL * L; WH] * V' = [0; WH * vertices] (step 1 & eq. 2)
        %disp(iter);
        A = [WL * L; WH];
        b = [zeros(numVertices, size(P, 2)); WH * P];
        Pcenter = A \ b; % Solve the system
        
        % Update weights (step 2)
        WL = sL * WL;
         % Compute the Euclidean distance between the current and previous positions
        %displacement = 1+ sqrt(sum((Pcenter - previous_Pcenter).^2, 2));
        %WH = spdiags(displacement, 0, numVertices, numVertices);
        %previous_Pcenter = Pcenter;

        % Calculate a new Laplacian with new vertex positions (step 3)
        newTR = triangulation(TR.ConnectivityList,Pcenter);
        L = curvatureflowlaplace(newTR);
        
        % Check for volume convergence
        current_volume = volume_of_mesh(newTR);
        ratio = current_volume / initial_volume;
        waitbar(iter/max_iterations,f,sprintf('Current iteration: %d, Volume ratio: %0.5e',iter, ratio))
        if ratio < epsilon_vol
            break;
        end
    end
    delete(f);
end

