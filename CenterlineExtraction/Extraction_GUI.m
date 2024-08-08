function Pcenter = Extraction_GUI(TR,max_iterations,sL,n,algorithm)
% Input:
%   TR - Triangular object
%   L - curvature-flow Laplacian
%   WL - Contraction weights
%   WH - Attraction weights
%   max_iterations - Maximum number of iterations to contract the mesh
%   sL - Growth factor of WL
%   n - Keep every n-th point
% Output:
%   Pcenter - Centerline points (contracted mesh points) 
    L = curvatureflowlaplace(TR);
    [WL, WH] = initweights(TR);
    Pcenter = contract_mesh(TR, L, WL, WH, max_iterations, sL);
    switch algorithm
        case 'Nearest neighbor rearranging'
        Pcenter = postprocessing(Pcenter,n);
        otherwise
        Pcenter = postprocessing2(Pcenter,n);
    end
end

