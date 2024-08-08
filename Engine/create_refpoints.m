function [rP] = create_refpoints(x, y)
    % Calculate the unit vector
    % Determine the top edge (assuming the rectangle is axis-aligned)
    top_edge_indices = find(y == max(y));
    top_edge_x = x(top_edge_indices);
    btm_edge_indices = find(y == min(y));
    btm_edge_x = x(btm_edge_indices);
    
    % Center point of the top edge
    rP(1, :) = [(min(top_edge_x) + max(top_edge_x)) / 2, max(y), 0];
    rP(2, :) = [(min(btm_edge_x) + max(btm_edge_x)) / 2, min(y), 0];
    
end