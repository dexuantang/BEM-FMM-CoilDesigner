function E = fmm_electric_field_multi(coilgroup, points, mu0)
% E-field helper for multiple coils
        E = zeros;
    for n = 1:length(coilgroup)
        E = E + fmm_electric_field(coilgroup(n), points, coilgroup(n).dIdt, mu0);
    end
end