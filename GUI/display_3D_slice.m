function [] = display_3D_slice(parent, X, Y, Z, V, caption, x,y,z,axes)
    switch axes
        case 'X'
            xslice = x;
            yslice = [];
            zslice = [];
        case 'Y'
            xslice = [];
            yslice = y;
            zslice = [];
        case 'Z'
            xslice = [];
            yslice = [];
            zslice = z;
    end
    slice(parent,X,Y,Z,V,xslice,yslice,zslice);
    axis(parent, 'equal');
    axis(parent, 'tight'); 
    colorbar(parent);
    view(parent, -38, 24);
    title(parent, caption);
    xlabel(parent,'X (m)');
    ylabel(parent,'Y (m)');
    zlabel(parent,'Z (m)');
    set(parent,'fontsize',20)
end

