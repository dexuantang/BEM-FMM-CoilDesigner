function E = fmm_electric_field_multi_sphere(coilgroup, points, mu0)
    % Initialize total fields
    E = zeros(size(points));
    for n = 1:length(coilgroup)
        % Compute the electric field for the current coil
        Etemp = fmm_electric_field(coilgroup(n), points, coilgroup(n).dIdt, mu0);
        
        % Accumulate electric field
        E = E + Etemp;
        
    end

end
