function [strcoil] = coil_helix(options)
%  Define a helix coil
%  Inputs:
%  radius - Radius of the coil bore in meters
%  pitch - Seperation between each turn in the helix in meters
%  turns -  Number of turns
%  crosssection -  Shape of the cross-section:  Ellipse, or Rectangle
%  a - length of the cross-section.
%  b - Width of the cross-section. 
%   Outputs:
%   P       -  P-aray of surface mesh vertices
%   t       -  t-array of surface triangular facets
%   normals - array of outer normal vectors
%   strcoil.Pwire       -  nodal points of current segments 
%   strcoil.Ewire       -  current segments in the form of edges
%   strcoil.Swire       -  weights of current segments, used to have 1 A of
%   total current over the cross-section and/or for other purposes
    arguments
        options.radius  double
        options.pitch   double
        options.turns   double
        options.crosssection    string
        options.a   double
        options.b   double
    end
    c = options.pitch/(2*pi);   %   2pi*c is a constant giving the vertical separation of the helix's loops

%   Define conductor centerline (a helix)
    t = linspace(0, 2*pi*options.turns, 2000);   %   parameteric variable 
    x = options.radius*cos(t);                   %   x, m
    y = options.radius*sin(t);                   %   y, m
    z = c*t - mean(c*t);            %   z, m
    Pcenter(:, 1) = x;
    Pcenter(:, 2) = y;
    Pcenter(:, 3) = z;
    %   Define cross-section shape (circle, ellipse, or rectangle in the xy plane)
    M           = 11;       %   number of cross-section subdivisions
    sk          = 0;        %   uniform current distribution through cross-section\

    if strcmp(options.crosssection, "Ellipse")
        [x, y]      = crosssection_ellipse(options.a, options.b, M);
    elseif strcmp(options.crosssection, "Rectangle")
        [x, y]      = crosssection_rect(options.a, options.b, M);
    else
        error('Unsupported cross-section shape.')
    end

    direction   = [0 0 1];    %   dominant cross-section orientation (if any) 
    
    %   Create wire-based model of the coil conductor(s)
    strcoil                 = pmeshwire(Pcenter, x, y, direction, sk, 0);
    %   Create surface CAD model of the coil conductor(s)
    [strcoil.P, strcoil.t, strcoil.normals]         = pmeshsurface(Pcenter, x, y, direction, 0);
end