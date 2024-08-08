function [strcoil] = coil_MagVenture_B_35()
    %   The coil is in the form of two non-interconnected spiral arms. The
    %   conductor centerline model is given first

    turns = 32;
    theta = [0:pi/20:turns*2*pi-pi/2];
    a0 = 0.0115; b0 = (23e-3 - a0)/(turns*2*pi-pi/2);
    r = a0 + b0*theta;                 %   Archimedean spiral
    x = r.*cos(theta);                 %   first half
    y = r.*sin(theta);                 %   first half
    
    % plot(x, y, '*-'); axis equal; grid on; title('Conductor centerline');
    % return
    
    %   Other parameters
    a    = 15e-3;       %   z-side, m  (for a rectangle cross-section)
    b    = 0.2e-3;      %   x-side, m  (for a rectangle cross-section)
    M    = 20;          %   number of cross-section subdivisions 
    flag = 2;           %   rect. cross-section    
    sk   = 0;           %   Litz wire
    
    %   Create CAD and wire models for the single conductor
    Pcenter(:, 1) = x';
    Pcenter(:, 2) = y';
    Pcenter(:, 3) = a/2;
    strcoil       = meshwire2(Pcenter, a, b, M, flag, sk);
    [P, t]        = meshsurface2(Pcenter, a, b, M, flag);  %   CAD mesh (optional, slow)     
    tind          = 1*ones(size(t, 1), 1);
    
    Ewire       = [];
    Pwire       = []; 
    Swire       = [];
    Pa          = [];
    ta          = []; 
    
    %   Construct two CAD and wire models 
    strcoil.Swire       = [strcoil.Swire; strcoil.Swire];
    strcoil.Ewire       = [strcoil.Ewire; strcoil.Ewire+size(strcoil.Pwire, 1)];
    Pwire1              = strcoil.Pwire;
    Pwire2              = strcoil.Pwire;
    Pwire1(:, 1)        = -Pwire1(:, 1);
    Pwire1(:, 1)        = Pwire1(:, 1) - 23e-3;
    Pwire2(:, 1)        = Pwire2(:, 1) + 23e-3;
    strcoil.Pwire       = [Pwire1; Pwire2]; 
    strcoil.Pwire(:, 3) = strcoil.Pwire(:, 3) - min(strcoil.Pwire(:, 3));
    
    t          = [t; t+size(P, 1)];
    tind       = [tind; 2*tind];
    P1         = P;
    P2         = P;
    P1(:, 1)   = -P1(:, 1);
    P1(:, 1)   = P1(:, 1) - 23e-3;
    P2(:, 1)   = P2(:, 1) + 23e-3;
    P          = [P1; P2]; 
    P(:, 3)    = P(:, 3) - min(P(:, 3)); 
    strcoil.P = P;
    strcoil.t = t;
end

