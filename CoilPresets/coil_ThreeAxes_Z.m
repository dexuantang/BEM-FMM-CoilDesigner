function [strcoil] = coil_ThreeAxes_Z()
    %   Common parameters
    a    = 1.30e-3;     %   Litz wire radius
    M    = 12;          %   number of cross-section subdivisions 
    N    = 64;          %   number of perimeter subdivisions
    flag = 1;           %   circular cross-section    
    sk   = 0;           %   uniform current distribution (Litz wire)
    %--------------------------------------------------------------------------
    %   Z-coil (Z-component of the coil array)
    %   When crossing the xz-plane, the intersection points for the loop
    %   centerlines are
    x0(1:5) = 1e-3*16.0395*ones(1, 5) + a*[0 2 4 6 8];
    x0(6:10)  = x0(1:5);
    x0(11:14) = x0(2:5);
    x0(15:17) = x0(3:5);
    z0(1:5)      = 0.9045e-3;
    z0(6:10)     = 0.9045e-3  + 2*a;
    z0(11:14)    = 0.9045e-3  + 4*a;
    z0(15:17)    = 0.9045e-3  + 6*a; 
    
    %   Construct the mesh for the coil
    [PwireZ, EwireZ, SwireZ, PZ, tZ, tindZ] = meshcoil2(x0, x0, z0, M, N, a, a, flag, sk); 

    %  Put in struct
    strcoil.Pwire       = PwireZ;
    strcoil.Ewire       = EwireZ;
    strcoil.Swire       = SwireZ;
    strcoil.P           = PZ;
    strcoil.t           = tZ;
     
end

