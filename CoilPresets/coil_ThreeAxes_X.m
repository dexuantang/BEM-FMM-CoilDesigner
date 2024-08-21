function [strcoil] = coil_ThreeAxes_X()
    %   Common parameters
    a    = 1.30e-3;     %   Litz wire radius
    M    = 12;          %   number of cross-section subdivisions 
    N    = 64;          %   number of perimeter subdivisions
    flag = 1;           %   circular cross-section    
    sk   = 0;           %   uniform current distribution (Litz wire)
    %--------------------------------------------------------------------------
    %   X-coil (X-component of the coil array)
    %   When crossing the xz-plane, the intersection points for the loop
    %   centerlines are
    %   Outer coil part
    x01 = 1e-3*[18.1835 19.227 20.076 20.720 21.153 21.3705 21.3705 21.153 20.720...
                20.0760 19.227 18.1835];
    %   Inner coil part
    x02 = 1e-3*[14.3865 15.4325 16.2325 16.773 17.0455 17.0455 16.773 16.2325 15.4325...
                14.3865];
    x0  = [x01 x02];         
    %   Outer coil part
    z01 = 1e-3*[-11.279 -9.389 -7.403 -5.343 -3.228 -1.0795 +1.0795 +3.228 +5.343...
                +7.403 +9.389 +11.279];
    %   Inner coil part
    z02 = 1e-3*[-9.205 -7.317 -5.312 -3.221 -1.0795 +1.0795 +3.221 +5.312 +7.317...
                +9.205];
    z0  = [z01 z02]; 
            
    %   Construct the mesh for the coil
    [PwireX, EwireX, SwireX, PX, tX, tindX] = meshcoil2(x0, x0, z0, M, N, a, a, flag, sk);  

        %--------------------------------------------------------------------------
    %   Construct the entire coil aray as a combination of three parts
    %   Rotate (about the x-axis) and then move the X-coil as appropriate
    Nx = 1; Ny = 0; Nz = 0;
    MoveX = 0; MoveY = 0; MoveZ = 24.638e-3;
    PwireX = meshrotate1(PwireX, Nx, Ny, Nz);
    PwireX(:, 1)   = PwireX(:, 1) + MoveX;
    PwireX(:, 2)   = PwireX(:, 2) + MoveY;
    PwireX(:, 3)   = PwireX(:, 3) + MoveZ;
    PX = meshrotate1(PX, Nx, Ny, Nz);
    PX(:, 1)   = PX(:, 1) + MoveX;
    PX(:, 2)   = PX(:, 2) + MoveY;
    PX(:, 3)   = PX(:, 3) + MoveZ;

    % Put in struct
    strcoil.Pwire       = PwireX;
    strcoil.Ewire       = EwireX;
    strcoil.Swire       = SwireX;
    strcoil.P           = PX;
    strcoil.t           = tX;
end

