function newPcenter = postprocessing2(Pcenter, n)
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
    
    % Remove points that are too close to each other
    threshold = 5e-4;
    keep_indices = true(size(Pcenter, 1), 1);
    
    % Use a nested loop to check all pairs of points
    for i = 1:size(Pcenter, 1)
        if keep_indices(i)
            for j = i+1:size(Pcenter, 1)
                if keep_indices(j) && norm(Pcenter(i, :) - Pcenter(j, :)) < threshold
                    keep_indices(j) = false;
                end
            end
        end
    end
    newPcenter = Pcenter(keep_indices, :);
end
