function [ ] = display_CADmodel_GUI(parent, P, t, ind, alpha, beta, transparency, label)
    % Display CAD model
    if nargin == 6
        transparency = 0.8;
        label = [];
    end
    if nargin == 7
        label = [];
    end

    % Check and set OpenGL to hardware. Speeds up plotting but may cause
    % compatibility issues in the future
    try
        opengl hardware;
    catch
        warning('Hardware OpenGL is not available. Falling back to software OpenGL.');
        opengl software;
    end

    set(parent, 'Color', 'White');
    p = patch(parent, 'vertices', P, 'faces', t, 'EdgeColor', 'none', ...
        'FaceColor', [1 0.75 0.65], 'FaceAlpha', transparency);
    if ~ind
        p.EdgeColor = 'none';
    else
        p.EdgeColor = 'k';
    end
    axis(parent, 'equal');
    axis(parent, 'tight'); 
    lightangle(parent, alpha, beta);
    lighting(parent, 'gouraud');
    set(parent, 'fontsize', 20)
    xlabel(parent, 'X (m)');
    ylabel(parent, 'Y (m)');
    zlabel(parent, 'Z (m)');
    setAxes3DPanAndZoomStyle(zoom(parent),parent,'camera')
    view(parent, alpha, beta);

    % Add label as text beside the mesh
    if ~isempty(label)
        % Calculate the position for the label
        % Here we take the mean of the vertices to find a central position
        meanP = mean(P, 1);
        text(parent, meanP(1), meanP(2), max(P(:, 3) + 0.001), ...
            append('Coil ID: ', label), 'FontSize', 20, 'Color', 'black');
    end

end
