function M = fmm_mutual_inductance(strcoil1, strcoil2, mu0)    
%   Computes Neumann integral - the mutual inductance
%
%   Copyright SNM 2020

    %   Compute pseudo potentials             
    segvector1   =     (strcoil1.Pwire(strcoil1.Ewire(:, 2), :) - strcoil1.Pwire(strcoil1.Ewire(:, 1), :)).*repmat(strcoil1.Swire, 1, 3);
    segpoints1   = 0.5*(strcoil1.Pwire(strcoil1.Ewire(:, 1), :) + strcoil1.Pwire(strcoil1.Ewire(:, 2), :));
    segvector2   =     (strcoil2.Pwire(strcoil2.Ewire(:, 2), :) - strcoil2.Pwire(strcoil2.Ewire(:, 1), :)).*repmat(strcoil2.Swire, 1, 3);
    segpoints2   = 0.5*(strcoil2.Pwire(strcoil2.Ewire(:, 1), :) + strcoil2.Pwire(strcoil2.Ewire(:, 2), :));
    
    PseudoQx    = segvector1(:, 1);
    PseudoQy    = segvector1(:, 2);
    PseudoQz    = segvector1(:, 3);        
    const       = mu0/(4*pi);  % normalization    
     
    %   FMM 2020
    srcinfo.nd      = 3;                            %   three charge vectors    
    srcinfo.sources = segpoints1';                  %   source points
    targ            = segpoints2';                  %   target points
    prec            = 1e-3;                         %   precision    
    pg      = 0;                                    %   nothing is evaluated at sources
    pgt     = 1;                                    %   potential is evaluated at target points
    srcinfo.charges(1, :)    = PseudoQx.';     %   charges
    srcinfo.charges(2, :)    = PseudoQy.';     %   charges
    srcinfo.charges(3, :)    = PseudoQz.';     %   charges
    U                        = lfmm3d(prec, srcinfo, pg, targ, pgt);
    neumann(:, 1)               = const*U.pottarg(1, :)';
    neumann(:, 2)               = const*U.pottarg(2, :)';
    neumann(:, 3)               = const*U.pottarg(3, :)'; 
    M = sum(sum(neumann.*segvector2, 2), 1);     
end