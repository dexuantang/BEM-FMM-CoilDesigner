function [strcoil] = coil_H1()
    load('H1_centerline.mat');
    
    % Pcenter1 = (Pcenter(1:end-1, :)+Pcenter(2:end, :))/2;
    % PcenterNew = zeros(2*size(Pcenter, 1)-1, 3);
    % for m = 1:2:2*size(Pcenter, 1)-1
    %     PcenterNew(m, :) = Pcenter(floor(m/2)+1, :);
    % end
    % for m = 2:2:2*size(Pcenter, 1)-1
    %     PcenterNew(m, :) = Pcenter1(floor(m/2), :);
    % end
    % Pcenter = PcenterNew;
    %   Define cross-section shape (circle, ellipse, or rectrangle in xy plane)
    a           = 0.005;    %   x size in m
    b           = 0.005;    %   y size in m
    M           = 32;       %   number of cross-section subdivisions
    sk          = 0;        %   surface-based current distribution through cross-section
    [x, y]      = crosssection_ellipse(a, b, M);
    direction   = [0 0 0];    %   dominant cross-section orientation (if any) 
    %   Create wire-based model of the coil conductor(s)
    strcoil                 = meshwire(Pcenter, x, y, direction, sk, 0);
    %   Create surface CAD model of the coil conductor(s)
    [P, t, normals]         = meshsurface(Pcenter, x, y, direction, 0); 
    strcoil.P = P;
    strcoil.t = t;
    strcoil.normals = normals;
end
