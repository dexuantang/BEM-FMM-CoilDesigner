function [P, t, normals] = pmeshsurface(Pcenter, x, y, direction, phi)
%   Outputs a 2-manifold P, t mesh for a single arbitrarily bent conductor
%   in 3D, with an arbitrary cross section. The conductor could be either
%   open or closed. In the first case, the conductor is closed with flat
%   caps.  In the second case, the start point and the end point must
%   coincide.
%
%   Inputs:
%   Pcenter - centerline of the conductor in 3D Pcenter(:, 1:3) in meters;
%   x - x-coordinates of the cross-section contour in the xy-plane in meters;
%   y - y-coordinates of the cross-section contour in the xy-plane in meters;
%   direction - preferred orientation direction for a non-circular
%   cross-section
%   phi - extra rotation angle for the cross-section (for a heavily twisted Litz wire)
%
%   Outputs:
%   P       -  P-aray of surface mesh vertices
%   t       -  t-array of surface triangular facets
%   normals - array of outer normal vectors
%   Copyright SNM/JGF 2022-2023

    %   Check if the cross-section is a circle and zero direction, just in
    %   case
    check = sqrt(x.^2+y.^2);
    if std(check)<1e-9
        direction = 0*direction;
    end

    %   Create surface mesh for the cross-section
    [Pcross, tcross]        = meshfill(x, y);
    NC                      = size(Pcross, 1);
    rP = create_refpoints(x, y);
    NrP         = size(rP, 1);

    %   Create vector segments along the path
    PathVector      = Pcenter(2:end, :) - Pcenter(1:end-1, :);

    %   Add termination segments for the directional plane method
    Closed          = norm(Pcenter(1, :)-Pcenter(end, :))<1e-6*(norm(Pcenter(1, :)+Pcenter(end, :)));
    if Closed
        PathVector = [PathVector; PathVector(1, :)];
    else
        PathVector = [PathVector; PathVector(end, :)];
    end

    %   Create unit directional vectors
    UnitPathVector      = PathVector./repmat(vecnorm(PathVector')', 1, 3);

    %   Pcontour
    Pcontour(:, 1) = x';
    Pcontour(:, 2) = y';
    Pcontour(:, 3) = 0;
    edges(:, 1) = [1:size(Pcontour, 1)  ]';
    edges(:, 2) = [2:size(Pcontour, 1) 1]';
    NE          = size(edges, 1);   % number of nodes/edges in the cross-section
  
    %   Alight with the path in a simple way
    Pcontour    = meshrotate(Pcontour, ...
        UnitPathVector(1, 1), UnitPathVector(1, 2), UnitPathVector(1, 3));     
    Pcross      = meshrotate(Pcross, ...
        UnitPathVector(1, 1), UnitPathVector(1, 2), UnitPathVector(1, 3)); 
    rP          = meshrotate(rP, ...
        UnitPathVector(1, 1), UnitPathVector(1, 2), UnitPathVector(1, 3)); 
    %   Align with the path using dominant direction
    if norm(direction)>0
        angle = pcorrection(direction, UnitPathVector(1, :), rP);
        Pcontour    = meshrotate_axis(Pcontour, UnitPathVector(1, :), -angle);
        Pcross      = meshrotate_axis(Pcross, UnitPathVector(1, :), -angle);
        rP      = meshrotate_axis(rP, UnitPathVector(1, :), -angle);
    end

    %   Align the object cross-section with the first point of the first segment
    ptemp       = Pcontour + repmat(Pcenter(1, :), NE, 1);   
    Pcross      = Pcross + repmat(Pcenter(1, :), NC, 1); 
    rptemp      = rP + repmat(Pcenter(1, :), NrP, 1);

    %   Add nodes/triangles for the side surface (the main loop)
     %  And move the inner nodes along the path
    t               = [];
    P               = ptemp;
    Pcrossend       = Pcross;
    Steps           = size(PathVector, 1) - 1;
    for m = 1:Steps
        %   Define the normal vector of the directional plane
        PlaneNormal = UnitPathVector(m, :) + UnitPathVector(m+1, :);
        PlaneNormal = PlaneNormal/norm(PlaneNormal);
        %   Construct intersections with the directional plane
        for n = 1:NE
            [ptemp(n, :),  ~] = line_plane_intersection(UnitPathVector(m, :), ptemp(n, :), PlaneNormal, Pcenter(m+1, :));
        end
        %   Construct intersections with the directional plane
        for n = 1:NC
            [Pcrossend(n, :),  ~] = line_plane_intersection(UnitPathVector(m, :), Pcrossend(n, :), PlaneNormal, Pcenter(m+1, :));
        end
        for i = 1:NrP
            [rptemp(i, :),  ~] = line_plane_intersection(UnitPathVector(m, :), rptemp(i, :), PlaneNormal, Pcenter(m+1, :));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Rotate the cross-section to align with the dominant
        %   direction
        if norm(direction)>0
            MEAN            = mean(ptemp, 1);
            ptempmean       = repmat(MEAN, size(ptemp, 1), 1);
            rPMEAN          = mean(rptemp, 1);
            rptempmean      = repmat(rPMEAN, size(rptemp, 1), 1);
            Pcrossendmean   = repmat(MEAN, size(Pcrossend, 1), 1);
            angle       = pcorrection(direction, UnitPathVector(m+1, :), rptemp-rptempmean);
            ptemp           = meshrotate_axis(ptemp-ptempmean, UnitPathVector(m, :), -angle) + ptempmean;
            Pcrossend       = meshrotate_axis(Pcrossend-Pcrossendmean, UnitPathVector(m, :), -angle) + Pcrossendmean;
            rptemp          = meshrotate_axis(rptemp-rptempmean, UnitPathVector(m, :), -angle) + rptempmean;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Extra rotate the cross-section
        if abs(phi)>0
            MEAN            = mean(ptemp, 1);
            ptempmean       = repmat(MEAN, size(ptemp, 1), 1);
            Pcrossendmean   = repmat(MEAN, size(Pcrossend, 1), 1);
            ptemp           = meshrotate_axis(ptemp-ptempmean, UnitPathVector(m, :), phi) + ptempmean;
            Pcrossend       = meshrotate_axis(Pcrossend-Pcrossendmean, UnitPathVector(m, :), phi) + Pcrossendmean;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Condition the last step
        if m == Steps&Closed
            P(1:size(ptemp, 1), :)  = ptemp;
            Pcross = Pcrossend;
        end 
        P = [P; ptemp];        
        %   Local connectivity: from the previous layer to the next layer
        t1(:, 1:2)      = edges;                        %   Lower nodes        
        t1(:, 3)        = edges(:, 1) + NE;             %   Upper node
        t2(:, 2:-1:1)   = edges       + NE;             %   Upper nodes
        t2(:, 3)        = edges(:, 2);                  %   Lower node
        ttemp           = [t1; t2];
        t               = [t; ttemp+NE*(m-1)];
    end
    normals = meshnormals(P, t);
    
    
    %   Now close the conductor with two flat caps
    normalscross    = -repmat(UnitPathVector(1, :), size(tcross, 1), 1);
    normalscrossend = +repmat(UnitPathVector(end, :), size(tcross, 1), 1);
    tcrossstart = flip(tcross,2);                       %   Right hand rule of STL
    if ~ Closed
        [P, t, normals] = meshcombine(P, Pcross, Pcrossend, t, tcrossstart, tcross, normals, normalscross, normalscrossend);
    end
    [P, t] = fixmesh(P, t, 1e-6);   % This number may be critical    
end

