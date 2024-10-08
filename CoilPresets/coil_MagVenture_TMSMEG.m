function [strcoil] = coil_MagVenture_TMSMEG()
    %   This function creates the mesh (both CAD surface mesh and a computational
    %   wire grid) for a simple TMS-MEG coil with 1 A of total current
    %   The output is saved in the binary file coil.mat and includes:
    %   strcoil.Pwire(:, 3) - set of nodes for all wires 
    %   strcoil.Ewire(:, 2) - set of edges or current dipoles for all wires
    %   (current flows from the first edge node to the second edge node)
    %   strcoil.Swire{:, 1} - current strength weight for every elementary
    %   dipole asssuring that the total conductor current through any
    %   cross-section is 1 A.
    
    %   Copyright SNM 2018-2020
    %   Updated by Dexuan Tang 2024

    %   The coil includes 18 coaxial circular turns/loops. The coil axis is the
    %   z-axis. When crossing the xz-plane, the intersection points for the
    %   loop centerlines are
    x0 = 1e-1*[ 0.1133    0.1506    0.1320    0.1694    0.1133    0.1506    0.1320    0.1694...
                0.1133    0.1506    0.1320    0.1694    0.1133    0.1506    0.1320    0.1694...
                0.1133    0.1506];
    z0 = 1e-2*[ 0.1079    0.1079    0.2172    0.2172    0.3239    0.3239    0.4331    0.4331...
                0.5397    0.5397    0.6490    0.6490    0.7556    0.7556    0.8649    0.8649...
                0.9716    0.9716];
    %   Other parameters
    a    = 0.0015;      %   conductor radius
    M    = 16;          %   number of cross-section subdivisions 
    N    = 64;          %   number of perimeter subdivisions
    flag = 1;           %   circular cross-section    
    sk   = 1;           %   surface current distribution (skin layer)
    
    %   Construct the combined coil mesh
    [Pwire, Ewire, Swire, P, t, tind] = meshcoil(x0, x0, z0, M, N, a, a, flag, sk);
    strcoil.Pwire = Pwire;
    strcoil.Pwire(:, 3) = strcoil.Pwire(:, 3) - min(strcoil.Pwire(:, 3));
    strcoil.Ewire = Ewire;
    strcoil.Swire = Swire;
    P(:, 3) = P(:, 3) - min(P(:, 3)); 
    
    strcoil.P = P;
    strcoil.t = t;
end