function [strcoil, coilarray, arr_flag] = coil_ThreeAxes(Xweight, Yweight, Zweight)
    %   This function creates the mesh (both CAD surface mesh and a computational
    %   wire grid) for a three-axis coil aray coil with 1 A of total current
    %   The output is saved in the binary file coil.mat and includes:
    %   strcoil.Pwire(:, 3) - set of nodes for all wires 
    %   strcoil.Ewire(:, 2) - set of edges or current dipoles for all wires
    %   (current flows from the first edge node to the second edge node)
    %   strcoil.Swire{:, 1} - current strength weight for every elementary
    %   dipole asssuring that the total conductor current through any
    %   cross-section is 1 A
    %   
    %   Copyright SNM 2018-2019, Modified by Dexuan Tang 2024
    
    %   The coil aray includes spherical turns/loops.  We construct X, Y, Z
    %   components of the coil array separately; all of them are initially
    %   oriented along the z-axis
    
    %   Common parameters
    a    = 1.30e-3;     %   Litz wire radius
    M    = 12;          %   number of cross-section subdivisions 
    N    = 64;          %   number of perimeter subdivisions
    flag = 1;           %   circular cross-section    
    sk   = 0;           %   uniform current distribution (Litz wire)
    coilarray = [];
    arr_flag = 1;
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
    [PwireX, EwireX, SwireX, PX, tX, tindX] = meshcoil(x0, x0, z0, M, N, a, a, flag, sk);  

    
    
    %--------------------------------------------------------------------------
    %   Y-coil (Y-component of the coil array)
    %   When crossing the xz-plane, the intersection points for the loop
    %   centerlines are
    %   Outer coil part
    x01 = 1e-3*[21.5805 22.3545 22.9405 23.3345 23.5315 23.5315 23.3345 22.9405 ...
                22.3545 21.5805];
    %   Inner coil part
    x02 = 1e-3*[17.7715 18.4855 18.9665 19.2085 19.2085 18.9665 18.4855 17.7715];
    x0  = [x01 x02];         
    %   Outer coil part
    z01 = 1e-3*[-9.444 -7.428 -5.350 -3.227 -1.0775 +1.0775 +3.227 +5.350 ...
                +7.428 +9.444];
    %   Inner coil part
    z02 = 1e-3*[-7.367 -5.330 -3.225 -1.0795 +1.0795 +3.225 +5.330 +7.367];
    z0  = [z01 z02]; 
            
    %   Construct the mesh for the coil
    [PwireY, EwireY, SwireY, PY, tY, tindY] = meshcoil(x0, x0, z0, M, N, a, a, flag, sk);  

    
    
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
    [PwireZ, EwireZ, SwireZ, PZ, tZ, tindZ] = meshcoil(x0, x0, z0, M, N, a, a, flag, sk); 

    
    
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
    %   Rotate (about the y-axis) and then move the Y-coil as appropriate
    Nx = 0; Ny = 1; Nz = 0;
    MoveX = 0; MoveY = 0; MoveZ = 24.638e-3;
    PwireY = meshrotate1(PwireY, Nx, Ny, Nz);
    PwireY(:, 1)   = PwireY(:, 1) + MoveX;
    PwireY(:, 2)   = PwireY(:, 2) + MoveY;
    PwireY(:, 3)   = PwireY(:, 3) + MoveZ;
    PY = meshrotate1(PY, Nx, Ny, Nz);
    PY(:, 1)   = PY(:, 1) + MoveX;
    PY(:, 2)   = PY(:, 2) + MoveY;
    PY(:, 3)   = PY(:, 3) + MoveZ;
    
    % Introduce array weights/excitations 
    % Xweight        = +1.0;
    % Yweight        = +1.0;
    % Zweight        = +1.0;
    
    %   Combine three parts together
    strcoil.Pwire       = [PwireX; PwireY; PwireZ];
    strcoil.Pwire(:, 3) = strcoil.Pwire(:, 3) - min(strcoil.Pwire(:, 3));
    strcoil.Ewire       = [EwireX; EwireY+size(PwireX, 1); EwireZ+size(PwireX, 1)+size(PwireY, 1)];
    strcoil.Swire       = [Xweight*SwireX; Yweight*SwireY; Zweight*SwireZ];
    strcoil.SX          = 1:length(SwireX);
    strcoil.SY          = 1+length(SwireX):length(SwireX)+length(SwireY);
    strcoil.SZ          = 1+length(SwireX)+length(SwireY):length(SwireX)+length(SwireY)+length(SwireZ);
    
    P           = [PX; PY; PZ];
    P(:, 3)     = P(:, 3) - min(P(:, 3));
    t           = [tX; tY+size(PX, 1); tZ+size(PX, 1)+size(PY, 1)];
    tind        = [1*ones(size(tX, 1), 1); 2*ones(size(tY, 1), 1); 3*ones(size(tZ, 1), 1)];
    [P, t]      = fixmesh(P, t);

    strcoil.P = P;
    strcoil.t = t;

    %   Array model
    strcoilX.Pwire       = PwireX;
    strcoilX.Pwire(:, 3) = strcoilX.Pwire(:, 3);
    strcoilX.Ewire       = EwireX;
    strcoilX.Swire       = SwireX;
    strcoilX.P           = PX;
    strcoilX.P(:, 3)     = strcoilX.P(:, 3) - min(strcoilX.P(:, 3));
    strcoilX.t           = tX;
    strcoilX.label        = 'X';
    coilarray = [coilarray;strcoilX];

    strcoilY.Pwire       = PwireY;
    strcoilY.Pwire(:, 3) = strcoilY.Pwire(:, 3) - min(strcoilY.Pwire(:, 3));
    strcoilY.Ewire       = EwireY;
    strcoilY.Swire       = SwireY;
    strcoilY.P           = PY;
    strcoilY.P(:, 3)     = strcoilY.P(:, 3) - min(strcoilY.P(:, 3));
    strcoilY.t           = tY;
    strcoilY.label        = 'Y';
    coilarray = [coilarray;strcoilY];

    strcoilZ.Pwire       = PwireZ;
    strcoilZ.Pwire(:, 3) = strcoilZ.Pwire(:, 3) - min(strcoilZ.Pwire(:, 3));
    strcoilZ.Ewire       = EwireZ;
    strcoilZ.Swire       = SwireZ;
    strcoilZ.P           = PZ;
    strcoilZ.P(:, 3)     = strcoilZ.P(:, 3) - min(strcoilZ.P(:, 3));
    strcoilZ.t           = tZ;
    strcoilZ.label        = 'Z';
    coilarray = [coilarray;strcoilZ];
     
    save('coil', 'strcoil');
    save('coilCAD', 'P', 't', 'tind');  %   optional, slow
end
