function [ ] = display_centerline(Pcenter)
    %   Display centerline
    figure; set(gcf,'Color','White');
    plot3(Pcenter(:, 1), Pcenter(:, 2), Pcenter(:, 3), '-or'); 
end