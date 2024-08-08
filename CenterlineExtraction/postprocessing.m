function newPcenter = postprocessing(Pcenter, n)
% Keep every n-th point and rearrange the points with a greedy search
% algorithm, removing points that are too close together because unevenly
% spaced points cause graphical glitches when sweeping a cross-section.
% Input:
%   Pcenter - Centerline points (Mx2 or Mx3 matrix)
%   n - Keep every n-th point
% Output:
%   newPcenter - Processed centerline points

    % Reduce the number of points
    Pcenter = Pcenter(1:n:end, :);

    % Fix the first row
    fixed_first = Pcenter(1, :);
    % Remove the first row from the points to be rearranged
    points = Pcenter(2:end, :);
    
    % Initialize the rearranged matrix with the fixed first row
    newPcenter = fixed_first;
    % Initialize the current point as the first row
    current_point = fixed_first;
    % Keep track of unvisited points
    unvisited = points;
    
 
    % Greedily select the closest points
    while ~isempty(unvisited)
        % Calculate distances from current_point to all unvisited points
        distances = pdist2(current_point, unvisited, 'euclidean');
        
        % Find the index of the closest point
        [~, min_idx] = min(distances);
        
        % Check if the closest point is farther than 5e-4 m
        if distances(min_idx) > 5e-4 
            % Add the closest point to the rearranged points
            newPcenter = [newPcenter; unvisited(min_idx, :)];
            
            % Update current_point to the closest point
            current_point = unvisited(min_idx, :);
        end
        
        % Remove the visited point from the unvisited list
        unvisited(min_idx, :) = [];
    end

end