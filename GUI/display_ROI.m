function [] = display_ROI(parent, x, y, z)
    % Define the minimum and maximum values for x, y, and z
    xmin = x(1);
    xmax = x(end);
    ymin = y(1);
    ymax = y(end);
    zmin = z(1);
    zmax = z(end);

    % Define the vertices of the box
    vertices = [
        xmin ymin zmin;
        xmin ymin zmax;
        xmin ymax zmin;
        xmin ymax zmax;
        xmax ymin zmin;
        xmax ymin zmax;
        xmax ymax zmin;
        xmax ymax zmax;
    ];

    % Define the faces of the box
    faces = [
        1 2 4 3; % Left face
        5 6 8 7; % Right face
        1 2 6 5; % Front face
        3 4 8 7; % Back face
        1 3 7 5; % Bottom face
        2 4 8 6; % Top face
    ];

    % Draw the box using patch
    patch(parent, 'Vertices', vertices, 'Faces', faces, 'FaceColor', 'k', 'FaceAlpha', 0, 'EdgeColor', 'k');
    set(parent,'fontsize',20)
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    zlabel(parent,'Z (m)');
end
