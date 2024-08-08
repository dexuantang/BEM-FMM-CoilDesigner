function E = bemf5_volume_field_sv(Points, c, Center, Area, prec)
%   Computes field for an array Points anywhere in space using
%   precomputed neighbor integrals assembled in sparse matrices
%
%   Copyright SNM 2017-2021
    
    %   FMM 2019
    srcinfo.sources = Center';                      %   source points
    targ            = Points';                      %   target points     
    pg      = 0;                                    %   nothing is evaluated at sources
    pgt     = 2;                                    %   field and potential are evaluated at target points
    srcinfo.charges = c.'.*Area';                   %   charges
    U               = lfmm3d(prec, srcinfo, pg, targ, pgt);
    E               = -U.gradtarg'/(4*pi); 
    
end