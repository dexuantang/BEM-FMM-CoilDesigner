function [strcoil] = coil_ThreeAxes_Y()
    %   Common parameters
    a    = 1.30e-3;     %   Litz wire radius
    M    = 12;          %   number of cross-section subdivisions 
    N    = 64;          %   number of perimeter subdivisions
    flag = 1;           %   circular cross-section    
    sk   = 0;           %   uniform current distribution (Litz wire)

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
    [PwireY, EwireY, SwireY, PY, tY, tindY] = meshcoil2(x0, x0, z0, M, N, a, a, flag, sk); 

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

    % Put in struct
    strcoil.Pwire       = PwireY;
    strcoil.Ewire       = EwireY;
    strcoil.Swire       = SwireY;
    strcoil.P           = PY;
    strcoil.t           = tY;

end

