function E = fmm_electric_field_multi(coilgroup, points, mu0, ygrids, xgrids, zgrids)
    % Initialize total fields
    E = zeros(size(points));
    Ax = zeros(ygrids, xgrids, zgrids);
    Ay = zeros(ygrids, xgrids, zgrids);
    Az = zeros(ygrids, xgrids, zgrids);

    for n = 1:length(coilgroup)
        % Compute the electric field for the current coil
        Etemp = fmm_electric_field(coilgroup(n), points, coilgroup(n).dIdt, mu0);
        
        % Accumulate electric field
        E = E + Etemp;
        
        % Extract electric field components
        Ex = Etemp(:,1);
        Ey = Etemp(:,2);
        Ez = Etemp(:,3);

        % Reshape components for quiver3 visualization
        Evx = reshape(Ex, ygrids, xgrids, zgrids);
        Evy = reshape(Ey, ygrids, xgrids, zgrids);
        Evz = reshape(Ez, ygrids, xgrids, zgrids);

        % Compute dt for the current coil
        %dt = coilgroup(n).I0 / coilgroup(n).dIdt;

        % Accumulate magnetic vector potential components
        Ax = Ax + (-Evx / coilgroup(n).dIdt);
        Ay = Ay + (-Evy / coilgroup(n).dIdt);
        Az = Az + (-Evz / coilgroup(n).dIdt);
    end

    % Combine components into 4D array for NIfTI output
    A(:,:,:,1) = permute(Ax,[2 1 3]);
    A(:,:,:,2) = permute(Ay,[2 1 3]);
    A(:,:,:,3) = permute(Az,[2 1 3]);
    
    niftiwrite(A, 'MagneticVectorPotential.nii');
    % disp('MagneticVectorPotential.nii saved');
    % figure;
    % quiver3(X, Y, Z, Ax, Ay, Az, 'Color', 'blue');
end
