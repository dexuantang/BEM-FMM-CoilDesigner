function [strcoil] = coil_custom(options)
    arguments
        options.Centerline (1,1) string = fullfile(pwd,'\temp\Pcenter.mat')
        options.crosssection    string
        options.a   double
        options.b   double
    end
        Ptemp = load(options.Centerline);
        fieldNames = fieldnames(Ptemp);
        Pcenter = Ptemp.(fieldNames{1});
    M           = 20;       %   number of cross-section subdivisions
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

