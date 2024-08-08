clear;
s = pwd; addpath([s, '\Engine']);
s = pwd; addpath([s, '\GUI']);
s1 = pwd; addpath([s1, '\CenterlineExtraction']);
s2 = pwd; addpath([s2, '\examples-for-testing']);
TR = stlread('CB60.STL');
L = curvatureflowlaplace(TR);
[WL, WH] = initweights(TR);
V_contracted = contract_mesh(TR, L, WL, WH, [], []);
Pcenter = postprocessing2(V_contracted,1);
TR1 = triangulation(TR.ConnectivityList,V_contracted);
%Pt = connectivitySurgery(TR1, 1, 1e-3);
%Pcenter2 = Pt.P;
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

figure;
ax1 = axes;
display_centerline_GUI(ax1,V_contracted);
figure;
ax2 = axes;
display_centerline_GUI(ax2,Pcenter);
% figure;
% ax2 = axes;
% 
% display_centerline_GUI(ax2,Pcenter2);
