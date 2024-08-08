function [ ] = display_CADmodel(P, t, ind, alpha, beta)
    %   Display CAD model
    figure; set(gcf,'Color','White');
    p = patch('vertices', P, 'faces', t, 'EdgeColor', 'none', 'FaceColor', [1 0.75 0.65]);
    if ~ ind
        p.EdgeColor = 'none';
    else
        p.EdgeColor = 'k';
    end
    view(alpha, beta)
    axis equal; axis tight; 
    lightangle(gca, alpha, beta);
    lighting gouraud;
end