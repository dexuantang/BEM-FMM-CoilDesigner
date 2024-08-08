clear;
[x, y] = crosssection_rect(0.005, 0.01, 13);
[P, t, unit_vector, vP] = vmeshfill(x, y);
axis = [1 0 0];
theta = 0;
[P1, rotated_vector, rotated_vP] = vmeshrotate_axis(P, axis, theta, unit_vector, vP);

figure
scatter3(P1(:,1), P1(:,2), P1(:,3))
hold on;
scatter3(rotated_vP(1,1), rotated_vP(1,2), rotated_vP(1,3), "red")

nx = 1;
ny = 0.5;
nz = 0.375;
[PP, VV, vPP]  = vmeshrotate(P, unit_vector, vP, nx, ny, nz);
figure
scatter3(PP(:,1), PP(:,2), PP(:,3)) 
hold on;
scatter3(vPP(1,1), vPP(1,2), vPP(1,3), "red")
direction = [1 0 0];
UnitPathVector = [0 1 0];
[phi] = vcorrection(direction, UnitPathVector, [1 0 0])