function [] = display_contourf(parent, x, y, z, V, caption, axes, layer)
    set(parent,'View',[0 90]);
    switch axes
        case 'X'
            [Xq, Yq] = meshgrid(linspace(min(y), max(y), 100), linspace(min(z), max(z), 100));
            Vq = interp2(y, z, squeeze(V(:,layer,:))', Xq, Yq, 'linear');
            [c,h] = contourf(parent, Xq, Yq, Vq, 15);
            xlabel(parent,'Y');
            ylabel(parent,'Z');

        case 'Y'
            [Xq, Yq] = meshgrid(linspace(min(x), max(x), 100), linspace(min(z), max(z), 100));
            Vq = interp2(x, z, squeeze(V(layer,:,:))', Xq, Yq, 'linear');
            [c,h] = contourf(parent, Xq, Yq, Vq, 15);
            xlabel(parent,'X');
            ylabel(parent,'Z');

        case 'Z'
            [Xq, Yq] = meshgrid(linspace(min(x), max(x), 100), linspace(min(y), max(y), 100));
            Vq = interp2(x, y, V(:,:,layer), Xq, Yq, 'linear');
            [c,h] = contourf(parent, Xq, Yq, Vq, 15);
            xlabel(parent,'X');
            ylabel(parent,'Y');
    end
    h.LevelList = round(h.LevelList, 2, 'significant');
    clabel(c, h)
    colorbar(parent, 'southoutside');
    axis(parent, 'equal');
    axis(parent, 'tight');
    title(parent, caption);
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    set(parent,'fontsize',20)
end
