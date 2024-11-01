function [] = display_CADmodel_Array(parent, coilgroup, ind, alpha, beta, transparency)
% Goes through coilgroup struct and displays coil array
    hold(parent, 'on');
    for n = 1:length(coilgroup)
        display_CADmodel_GUI(parent, coilgroup(n).P, coilgroup(n).t, ind, alpha, beta, transparency, coilgroup(n).label);
        display_GND(parent,coilgroup(n).Pwire);
    end
    setAxes3DPanAndZoomStyle(zoom(parent),parent,'camera')
    view(parent, alpha, beta);
end