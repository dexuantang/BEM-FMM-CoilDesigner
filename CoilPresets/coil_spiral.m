function [strcoil] = coil_spiral(options)
    arguments
        options.a0  double
        options.b0   double
        options.turns   double
        options.crosssection    string
        options.a   double
        options.b   double
    end
%%  Define coil model #1
%   Load  conductor centerline
theta_end = options.turns*2*pi;
theta = [0:pi/100:theta_end];
r = options.a0 + options.b0*theta; %   Archimedean spiral
x = r.*cos(theta);                 %   first half
y = r.*sin(theta);                 %   first half
Pcenter(:, 1) = x;
Pcenter(:, 2) = y;
Pcenter(:, 3) = 0;

%   Define cross-section shape (circle, ellipse, or rectrangle in xy plane)
M           = 20;       %   number of cross-section subdivisions
sk          = 0;        %   uniform current distribution through cross-section
if strcmp(options.crosssection, "Ellipse")
    [x, y]      = crosssection_ellipse(options.a, options.b, M);
elseif strcmp(options.crosssection, "Rectangle")
    [x, y]      = crosssection_rect(options.a, options.b, M);
else
    error('Unsupported cross-section shape.')
end
    direction   = [0 0 0];    %   dominant cross-section orientation (if any) 

%   Create wire-based model of the coil conductor(s)
strcoil                 = pmeshwire(Pcenter, x, y, direction, sk, 0);
%   Create surface CAD model of the coil conductor(s)
 [strcoil.P, strcoil.t, strcoil.normals] = pmeshsurface(Pcenter, x, y, direction, 0);



