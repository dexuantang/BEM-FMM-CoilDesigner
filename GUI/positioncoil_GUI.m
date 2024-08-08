function [strcoil] = positioncoil_GUI(strcoil, thetaX, thetaY, thetaZ, MoveX, MoveY, MoveZ)
    %%   Define coil position: rotate and then tilt and move the entire coil as appropriate
    
    strcoil.Pwire   = meshrotate_axis(strcoil.Pwire, [1 0 0], thetaX);
    strcoil.P   = meshrotate_axis(strcoil.P, [1 0 0], thetaX);
    strcoil.Pwire   = meshrotate_axis(strcoil.Pwire, [0 1 0], thetaY);
    strcoil.P   = meshrotate_axis(strcoil.P, [0 1 0], thetaY);
    strcoil.Pwire   = meshrotate_axis(strcoil.Pwire, [0 0 1], thetaZ);
    strcoil.P   = meshrotate_axis(strcoil.P, [0 0 1], thetaZ);

    strcoil.Pwire(:, 1)   = strcoil.Pwire(:, 1) + MoveX;
    strcoil.Pwire(:, 2)   = strcoil.Pwire(:, 2) + MoveY;
    strcoil.Pwire(:, 3)   = strcoil.Pwire(:, 3) + MoveZ;
    

    strcoil.P(:, 1)   = strcoil.P(:, 1) + MoveX;
    strcoil.P(:, 2)   = strcoil.P(:, 2) + MoveY;
    strcoil.P(:, 3)   = strcoil.P(:, 3) + MoveZ;



end

