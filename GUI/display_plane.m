function Title = display_plane(parent, x, y, z, axes, layer)
    % Retrieve existing patches from the UserData of parent
    userData = get(parent, 'UserData');
    if ~isempty(userData) && isfield(userData, 'patches')
        % Delete existing patches
        delete(userData.patches);
    end
    
    % Initialize new patches array
    new_patches = [];
    
    % Determine coordinates and create the new patch
    switch axes
        case 'Y'
            Y = y(layer);
            xmin = x(1);
            xmax = x(end);
            zmin = z(1);
            zmax = z(end);
            p = patch(parent, [xmin xmin xmax xmax], [Y Y Y Y], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.25);
            Title = ['Y = ', num2str(Y), ' m'];
            title(parent, Title);
        case 'X'
            X = x(layer);
            ymin = y(1);
            ymax = y(end);
            zmin = z(1);
            zmax = z(end);
            p = patch(parent, [X X X X], [ymin ymin ymax ymax], [zmin zmax zmax zmin], 'c', 'FaceAlpha', 0.25);
            Title = ['X = ', num2str(X), ' m'];
            title(parent, Title);
        case 'Z'
            Z = z(layer);
            xmin = x(1);
            xmax = x(end);
            ymin = y(1);
            ymax = y(end);
            p = patch(parent, [xmin xmin xmax xmax], [ymin ymax ymax ymin], [Z Z Z Z], 'c', 'FaceAlpha', 0.25);
            Title = ['Z = ', num2str(Z), ' m'];
            title(parent, Title);
    end
    
    % Add new patch to the new_patches array
    new_patches = [new_patches p];
    
    % Store new patches in the UserData of parent
    set(parent, 'UserData', struct('patches', new_patches));
    
    % Set view
    view(parent, 10, 20);
    set(parent,'fontsize',20)
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    zlabel(parent,'Z (m)');
end
