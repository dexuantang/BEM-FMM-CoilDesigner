clear;
TR = stlread('CB60.STL');
L = curvatureflowlaplace(TR);
[WL, WH] = initweights(TR);
V_contracted = contract_mesh(TR, L, WL, WH, [], []);
Pcenter = postprocessing(V_contracted,12);

% Plot original and contracted mesh
figure;
subplot(1, 2, 1);
trisurf(TR.ConnectivityList, TR.Points(:,1), TR.Points(:,2), TR.Points(:,3), ...
    'FaceColor', 'cyan', 'EdgeColor', 'black');
title('Original Mesh');
axis equal; view(3);

subplot(1, 2, 2);
trisurf(TR.ConnectivityList, V_contracted(:,1), V_contracted(:,2), V_contracted(:,3), ...
    'FaceColor', 'cyan', 'EdgeColor', 'black');
title('Contracted Mesh');
axis equal; view(3);
