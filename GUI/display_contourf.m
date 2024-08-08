function [] = display_contourf(parent, x, y, z, V, caption,axes,layer)
set(parent,'View',[0 90]);
    switch axes
        case 'X'
            [c,h] = contourf(parent,y, z, squeeze(V(:,layer,:))',15);
            xlabel(parent,'Y');
            ylabel(parent,'Z');

        case 'Y'
            [c,h] = contourf(parent,x, z, squeeze(V(layer,:,:))',15);
            xlabel(parent,'X');
            ylabel(parent,'Z');
        case 'Z'
            [c,h] = contourf(parent,x, y, V(:,:,layer),15);
            xlabel(parent,'X');
            ylabel(parent,'Y');
    end
    h.LevelList=round(h.LevelList,2,'significant');  %rounds levels to 2 sig-figs
    clabel(c,h)
    colorbar(parent, 'southoutside');
    axis(parent, 'equal');
    axis(parent, 'tight'); 
    title(parent, caption);
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    set(parent,'fontsize',20)
end

