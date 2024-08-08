function [] = display_contourf_Array(parent, x, y, z, V, caption,axes,layer, coilgroup)
    display_contourf(parent, x, y, z, V, caption,axes,layer);
    hold(parent, 'on');
    for n = 1:length(coilgroup)
       display_coil_cross_section(parent, x, y, z, coilgroup(n), axes, layer); 
    end
    
end

