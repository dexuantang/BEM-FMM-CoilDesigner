function [strcoil] = coil_MagVenture_C_B60()
    theta               = [3*pi/2:pi/25:12*pi];
    a0 = 0.017; b0 = 0.0006;            %   spiral parameters
    r = a0 + b0*theta;                  %   Archimedean spiral
    r(1:10) = r(1:10) + pi*b0*linspace(1, 0, 10); 
    x1 = r.*cos(theta);                 %   first half
    y1 = r.*sin(theta);                 %   first half
    x2 = 2*x1(end) - x1(end-1:-1:1);    %   second half
    y2 = 2*y1(end) - y1(end-1:-1:1);    %   second half
    xc = [x1 x2];  yc = [y1 y2];        %   join both halves
    p1(:, 1) = xc; p1(:, 2) = yc; p1(:, 3) = 0;
    p1(end-10:end, 3) = 5.6e-3*linspace(0, 1, 11)';
    p1(1:10, 3) = 5.6e-3*linspace(1, 0, 10)';
    p1([1 end], :) = [];
    
    %%  Define second centerline analytically 
    theta = [3*pi/2+1*pi:pi/25:12*pi-pi/4];
    a0 = 0.017; b0 = 0.0006;                                %   spiral parameters
    r = a0 + b0*theta;                                      %   Archimedean spiral
    xc = +r.*cos(theta);                                    %   left half
    yc = -r.*sin(theta);                                    %   left half
    yc(end-5:end) = yc(end-5);                            %   straight conductor
    p2(:, 1) = xc; p2(:, 2) = yc; p2(:, 3) = 5.6e-3;
    p2(:, 1) = (0.95)*(p2(:, 1)-min(p2(:, 1))) + min(p2(:, 1));   % scale 
    p2       = p2(end:-1:1, :);                             %   invert
    
    %%  Define third centerline analytically 
    %   This coil will be in the form of two interconnected spiral arms
    theta = [3*pi/2+1*pi:pi/25:12*pi+pi/2];
    a0 = 0.017; b0 = 0.0006;            %   spiral parameters
    r = a0 + b0*theta;                  %   Archimedean spiral
    xc = +r.*cos(theta);                %   right half
    yc = -r.*sin(theta);                %   right half
    xc = 2*x1(end) - xc(end-1:-1:1);    %   right half
    yc = 2*y1(end) - yc(end-1:-1:1);    %   right half
    xc(1:10) = xc(10);                  %   straight conductor
    p3(:, 1) = xc; p3(:, 2) = yc; p3(:, 3) = 5.6e-3;
    p3(:, 1) = (0.95)*(p3(:, 1)-max(p3(:, 1))) + max(p3(:, 1));   % scale
    p3       = p3(end:-1:1, :);                             %   invert
    
    %%  Combine all three centerlines together
    p = [p2; p1; p3];
    p(:, 1) = p(:, 1) - mean(p(:, 1));
    %   rotate all
    p = meshrotate_axis(p, [0 0 1], 0.07);
    
    %%   Define cross-section shape (circle, ellipse, or rectrangle in xy plane)
    a           = 5.5e-3;    %   x size in m
    b           = 4.0e-3;    %   y size in m
    M           = 20;        %   number of cross-section subdivisions
    sk          = 0;         %   (uniform Litz wire) current distribution through cross-section
    %[x, y]      = crosssection_ellipse(a, b, M);
    [x, y]     = crosssection_rect(a, b, M);
    direction   = [0 0 1];    %   dominant cross-section orientation (if any) 
    
    %%  Create coil model(s)
    Pcenter       = p; 
    %   Create wire-based model of the coil conductor(s)
    strcoil                 = meshwire(Pcenter, x, y, direction, sk, 0);
    %   Create surface CAD model of the coil conductor(s)
    [P, t, normals]         = meshsurface(Pcenter, x, y, direction, 0);
    
    %%  Put coil bottom exactly at zero
    strcoil.Pwire(:, 3) = strcoil.Pwire(:, 3)-min(strcoil.Pwire(:, 3));
    P(:, 3) = P(:, 3) - min(P(:, 3));
    strcoil.P = P;
    strcoil.t = t;
end