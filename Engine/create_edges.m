function Edgestemp = create_edges(A, B)
    % Number of points
    n = size(A, 1);
    
    % Initialize the connections matrix
    Edgestemp = zeros(n, 2);
    
    % Keep track of used points in B
    usedB = false(n, 1);
    
    % For each point in A, find the closest point in B
    for i = 1:n
        % Calculate distances from point A(i) to all points in B
        distances = sqrt(sum((B - A(i, :)).^2, 2));
        
        % Set distances to already used points in B to infinity
        distances(usedB) = inf;
        
        % Find the closest point in B
        [~, minIdx] = min(distances);
        
        % Record the connection
        Edgestemp(i, :) = [i, minIdx];
        
        % Mark the chosen point in B as used
        usedB(minIdx) = true;
    end
end


