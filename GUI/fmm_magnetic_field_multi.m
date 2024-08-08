function B = fmm_magnetic_field_multi(coilgroup, points, mu0)
% B-field helper for multiple coils
        B = zeros;
    for n = 1:length(coilgroup)
        B = B + fmm_magnetic_field(coilgroup(n), points, coilgroup(n).I0, mu0);
    end
end