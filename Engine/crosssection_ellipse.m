function [x, y] = crosssection_ellipse(a, b, M)
    x           = a/2*cos(2*pi*[0:M-1]/M);
    y           = b/2*sin(2*pi*[0:M-1]/M);
end