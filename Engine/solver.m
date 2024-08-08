function E = solver(S, Einc)
    P       = S.P;
    t       = S.t;
    normals = S.normals;
    contrast = 1;

    %  Fix triangle orientation (just in case, optional)
    t = meshreorient(P, t, normals);
    %   Process other mesh data
    Center      = 1/3*(P(t(:, 1), :) + P(t(:, 2), :) + P(t(:, 3), :));  %   face centers
    Area        = meshareas(P, t);  
    perc = 1e-4;
    
    %   Add accurate integration for electric field/electric potential on neighbor facets
    %   Indexes into neighbor triangles
    RnumberE        = 4;    %   number of neighbor triangles for analytical integration (fixed, optimized)
    ineighborE      = knnsearch(Center, Center, 'k', RnumberE);   % [1:N, 1:Rnumber]
    ineighborE      = ineighborE';           %   do transpose  
    [EC, PC, EFX, EFY, EFZ, PF] = meshneighborints(P, t, normals, Area, Center, RnumberE, ineighborE);
    
    %  Parameters of the iterative solution
    iter         = 10;              %    Maximum possible number of iterations in the solution 
    relres       = 1e-6;            %    Minimum acceptable relative residual 
    weight       = 1/2;             %    Weight of the charge conservation law to be added (empirically found)
    
    %  Right-hand side b of the matrix equation Zc = b. Compute pointwise
    %   Surface charge density is normalized by eps0: real charge density is eps0*c
    b        = 2*(sum(normals.*Einc, 2));        %  Right-hand side of the matrix equation    
    %  GMRES iterative solution 
    %MATVEC = @(c) bemf4_surface_field_lhs(c, Center, Area, normals, weight, EC);  Original    
    MATVEC = @(c) bemf4_surface_field_lhs(c, Center, Area, contrast, normals, weight, EC, perc);  
    [c, its, resvec] = fgmres(MATVEC, b, relres, 'restart', iter, 'x0', b, 'tol_exit', relres);

    %   Continuous secondary electric field just inside/outside conducting sphere
    [~, Eadd]  = bemf4_surface_field_electric_accurate(c, Center, Area, EFX, EFY, EFZ, PC);

    %   Total electric field just inside conducting sphere
    par = -1;    %      par=-1 -> E-field just inside surface; par=+1 -> E-field just outside surface     
    E = Einc + Eadd + par/(2)*normals.*repmat(c, 1, 3);    %   full field
    error_tang_vs_normal = norm(dot(E, normals, 2))/norm(cross(E, normals, 2))
end