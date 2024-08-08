function [x, y] = crosssection_rect(a, b, M)

    M4 = round(M/4);
    if a <= 3*b                              %thin sheet
        x = linspace(-a/2, +a/2, M4);        %   non-uniform grid
        y = -b/2:a/size(unique(x),2):b/2;    %   non-uniform grid
    else
        y = linspace(-b/2, +b/2, M4);        %   non-uniform grid
        x = -a/2:b/size(unique(y),2):a/2;    %   non-uniform grid
    end
    
    xc = [x, ...
          x(end)*ones(1, length(y)-2),...
          x(end:-1:1),...
          x(1)*ones(1, length(y)-2)];
      
    yc = [y(1)*ones(1, length(x)),...
          y(2:end-1),...
          y(end)*ones(1, length(x)),...
          y(end-1:-1:2)];
      
    x = xc; y = yc;
    
end