function strcoil = pmeshwire(Pcenter, x, y, direction, sk, phi)
%   Outputs a computational wire mesh for a single arbitrarily bent conductor
%   in 3D, with an arbitrary cross section. The conductor could be either
%   open or closed. In the first case, the conductor is closed with flat
%   caps.  In the second case, the start point and the end point must
%   coincide.
%   Inputs:
%   Pcenter - centerline of the conductor in 3D Pcenter(:, 1:3) in meters;
%   x - x-coordinates of the cross-section contour in the xy-plane in meters;
%   y - y-coordinates of the cross-section contour in the xy-plane in meters;
%   direction - preferred orientation direction for a non-circular
%   cross-section
%   Parameter sk equals to zero for uniform current distribution (Litz wire)
%   or to 1 for the skin effect (bulk of the current flows close to the
%   surface)
%   phi - extra rotation angle for the cross-section (for a heavily twisted Litz wire)
%   Outputs:
%   strcoil.Pwire       -  nodal points of current segments 
%   strcoil.Ewire       -  current segments in the form of edges
%   strcoil.Swire       -  weights of current segments, used to have 1 A of
%   total current over the cross-section and/or for other purposes
%   Copyright SNM/JGF 2022/2023

    %   Check if the cross-section is a circle and zero direction, just in
    %   case
    check = sqrt(x.^2+y.^2);
    if std(check)<1e-9
        direction = 0*direction;
    end
    

    %   Create surface mesh for the cross-section
    [Pcross, tcross]        = meshfill(x, y);
    rP = create_refpoints(x, y);

    %   Process triangular mesh for the initial cross-section
    edges   = meshconnee(tcross); 
    areas   = meshareas(Pcross, tcross);    
    Pcross  = meshtricenter(Pcross, tcross);      

    %   Determine weights including border triangles (if necessary)
    if sk == 0
       weights     = areas/sum(areas);  % uniform curent distribution/weights
    else
        at    = meshconnet(tcross, edges, "nonmanifold"); % triangles attached to every edge
        tborder = [];
        for m = 1:length(at)
            if at{m}(2)==0
                tborder = [tborder at{m}(1)];
            end
        end
        weights  = areas(tborder)/sum(areas(tborder));
        Pcross   = Pcross(tborder, :); 
    end
    NC         = size(Pcross, 1);
    NrP         = size(rP, 1);

    %   Create vector segments along the path
    PathVector      = Pcenter(2:end, :) - Pcenter(1:end-1, :);
    %   Add termination segments for the directional plane method
    Closed          = norm(Pcenter(1, :) - Pcenter(end, :))<1e-9*(norm(Pcenter(1, :)+Pcenter(end, :)));
    if Closed
        PathVector = [PathVector; PathVector(1, :)];
    else
        PathVector = [PathVector; PathVector(end, :)];
    end
    
    %   Create unit directional vectors
    UnitPathVector      = PathVector./repmat(vecnorm(PathVector')', 1, 3);

    %   Alight with the path in a simple way
    Pcross     = meshrotate(Pcross, ...
        UnitPathVector(1, 1), UnitPathVector(1, 2), UnitPathVector(1, 3)); 

    %   Alight the reference with the path in a simple way
    rP     = meshrotate(rP, ...
        UnitPathVector(1, 1), UnitPathVector(1, 2), UnitPathVector(1, 3)); 

    %   Align with the path using dominant 

    if norm(direction)>0
        angle = pcorrection(direction, UnitPathVector(1, :), rP);
        Pcross      = meshrotate_axis(Pcross, UnitPathVector(1, :), -angle);
        rP      = meshrotate_axis(rP, UnitPathVector(1, :), -angle);
    end

    %   Align the object cross-section with the first point of the first segment
    ptemp       = Pcross + repmat(Pcenter(1, :), NC, 1);
    rptemp       = rP + repmat(Pcenter(1, :), NrP, 1);
        
    %   Add nodes for the wire mesh loop
    P     = ptemp;
    Edges = [];
    
    Steps           = size(PathVector, 1) - 1;

    for m = 1:Steps
        %   Define the normal vector of the directional plane
        PlaneNormal = UnitPathVector(m, :) + UnitPathVector(m+1, :);
        PlaneNormal = PlaneNormal/norm(PlaneNormal);
        %   Construct intersections with the directional plane
        for n = 1:NC
            [ptemp(n, :),  ~] = line_plane_intersection(UnitPathVector(m, :), ptemp(n, :), PlaneNormal, Pcenter(m+1, :));
        end
        for i = 1:NrP
            [rptemp(i, :),  ~] = line_plane_intersection(UnitPathVector(m, :), rptemp(i, :), PlaneNormal, Pcenter(m+1, :));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Rotate the cross-section to align with the dominant
        %   direction using reference points
        if norm(direction)>0
            MEAN            = mean(ptemp, 1);
            ptempmean       = repmat(MEAN, size(ptemp, 1), 1);
            rPMEAN          = mean(rptemp, 1);
            rptempmean      = repmat(rPMEAN, size(rptemp, 1), 1);
            angle       = pcorrection(direction, UnitPathVector(m+1, :), rptemp-rptempmean);
            ptemp           = meshrotate_axis(ptemp-ptempmean, UnitPathVector(m, :), -angle) + ptempmean;
            rptemp          = meshrotate_axis(rptemp-rptempmean, UnitPathVector(m, :), -angle) + rptempmean;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Extra rotate the cross-section
        if abs(phi)>0
            MEAN = mean(ptemp, 1);
            ptempmean   = repmat(MEAN, size(ptemp, 1), 1);
            ptemp       = meshrotate_axis(ptemp-ptempmean, PlaneNormal, phi) + ptempmean;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %   Condition the last step
        if m == Steps&&Closed
            P(1:size(ptemp, 1), :) = ptemp;
        end
        % A = P(end+1-NC: end, :);
        P = [P; ptemp];

        % Local connectivity: search the closest point
        % Edgestemp = create_edges(A, ptemp);
        % Edgestemp(:, 1) = NC * (m - 1) + Edgestemp(:,1);
        % Edgestemp(:, 2) = NC * (m - 0) + Edgestemp(:,2);

        % Local connectivity: old method
        Edgestemp(:, 1) = NC * (m - 1) + [1:NC]';
        Edgestemp(:, 2) = NC * (m - 0) + [1:NC]';
        Edges           = [Edges; Edgestemp];
        
        
    end
    strcoil.Pwire       = P;
    strcoil.Ewire       = Edges;
    strcoil.Swire       = repmat(weights, Steps, 1);
end

