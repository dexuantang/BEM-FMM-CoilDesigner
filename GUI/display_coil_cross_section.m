% function [] = display_coil_cross_section(parent,  x, y, z, strcoil, axes, layer)
% set(parent,'View',[0 90]);
% P = strcoil.P;
% t = strcoil.t;
%     switch axes
%         case 'X'
%             [edges, TriP, TriM] = mt(t);
%             [Pi, ~, polymask, flag] = meshplaneintYZ(P, t, edges, TriP, TriM, x(layer));
%             if flag % intersection found                
%                 for n = 1:size(polymask, 1)
%                     i1 = polymask(n, 1);
%                     i2 = polymask(n, 2);
%                     line(parent,Pi([i1 i2], 2), Pi([i1 i2], 3), 'Color', "#7E2F8E", 'LineWidth', 2);
%                 end   
%             end
% 
%         case 'Y'
%             [edges, TriP, TriM] = mt(t);
%             [Pi, ~, polymask, flag] = meshplaneintXZ(P, t, edges, TriP, TriM, y(layer));
%             if flag % intersection found                
%                 for n = 1:size(polymask, 1)
%                     i1 = polymask(n, 1);
%                     i2 = polymask(n, 2);
%                     line(parent,Pi([i1 i2], 1), Pi([i1 i2], 3), 'Color', "#7E2F8E", 'LineWidth', 2);
%                 end
%             end
%         case 'Z'
%             [edges, TriP, TriM] = mt(t);
%             [Pi, ~, polymask, flag] = meshplaneintXY(P, t, edges, TriP, TriM, z(layer));
%             if flag % intersection found                
%                 for n = 1:size(polymask, 1)
%                     i1 = polymask(n, 1);
%                     i2 = polymask(n, 2);
%                     line(parent,Pi([i1 i2], 1), Pi([i1 i2], 2), 'Color', "#7E2F8E", 'LineWidth', 2);
%                 end
%             end
%     end
%     xlabel(parent,'X (m)');
%     ylabel(parent,'Y (m)');
%     set(parent,'fontsize',20)
% end

function [] = display_coil_cross_section(parent,  x, y, z, strcoil, axes, layer)
    set(parent, 'View', [0 90]);
    P = strcoil.P;
    t = strcoil.t;
    [edges, TriP, TriM] = mt(t);

    switch axes
        case 'X'
            coord = x(layer);
            [Pi, ~, polymask, flag] = meshplaneintYZ(P, t, edges, TriP, TriM, coord);
            dim1 = 2; dim2 = 3;
        case 'Y'
            coord = y(layer);
            [Pi, ~, polymask, flag] = meshplaneintXZ(P, t, edges, TriP, TriM, coord);
            dim1 = 1; dim2 = 3;
        case 'Z'
            coord = z(layer);
            [Pi, ~, polymask, flag] = meshplaneintXY(P, t, edges, TriP, TriM, coord);
            dim1 = 1; dim2 = 2;
    end

    if flag % intersection found
        for n = 1:size(polymask, 1)
            i1 = polymask(n, 1);
            i2 = polymask(n, 2);
            line(parent, Pi([i1 i2], dim1), Pi([i1 i2], dim2), 'Color', "#7E2F8E", 'LineWidth', 2);
        end
    end

    xlabel(parent, 'X (m)');
    ylabel(parent, 'Y (m)');
    set(parent, 'fontsize', 20);
end
