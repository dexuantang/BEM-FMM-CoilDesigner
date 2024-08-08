function [indMat] = fmm_inductance_matrix(coilgroup, mu0)
    for i = 1:length(coilgroup)
        for j = 1:length(coilgroup)
            indMat(i,j) = fmm_mutual_inductance(coilgroup(i), coilgroup(j),mu0);
        end
    end
end