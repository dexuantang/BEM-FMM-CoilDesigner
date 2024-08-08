function [ ] = display_centerline_GUI(parent,Pcenter)
    %   Display centerline
    set(parent,'Color','White');
    plot3(parent, Pcenter(:, 1), Pcenter(:, 2), Pcenter(:, 3), '-or'); 
    axis(parent, 'equal');
    axis(parent, 'tight'); 
end