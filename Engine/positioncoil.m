function [strcoil] = positioncoil(strcoil, theta, Nx, Ny, Nz, MoveX, MoveY, MoveZ)
    %%   Define coil position: rotate and then tilt and move the entire coil as appropriate
    
    %   Step 1 Rotate the coil about its axis as required (pi/2 - anterior; 0 - posterior)
    coilaxis        = [0 0 1];
    strcoil.Pwire   = meshrotate_axis(strcoil.Pwire, coilaxis, theta);
    strcoil.P   = meshrotate_axis(strcoil.P, coilaxis, theta);

    %   Step 2 Tilt the coil axis with direction vector Nx, Ny, Nz as required
    strcoil.Pwire   = meshrotate(strcoil.Pwire, Nx, Ny, Nz);
    strcoil.P       = meshrotate(strcoil.P, Nx, Ny, Nz);


    %   Step 3 Move the coil as required
    strcoil.Pwire(:, 1)   = strcoil.Pwire(:, 1) + MoveX;
    strcoil.Pwire(:, 2)   = strcoil.Pwire(:, 2) + MoveY;
    strcoil.Pwire(:, 3)   = strcoil.Pwire(:, 3) + MoveZ;

    strcoil.P(:, 1)   = strcoil.P(:, 1) + MoveX;
    strcoil.P(:, 2)   = strcoil.P(:, 2) + MoveY;
    strcoil.P(:, 3)   = strcoil.P(:, 3) + MoveZ;
end

