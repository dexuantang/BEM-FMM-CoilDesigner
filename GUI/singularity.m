function [pairs, data] = singularity(strcoil, points, data, threshold)
    % Find points that are too close to the coil wires and assign them
    % the field data from nearby non-singularity points
    % Inputs:
    %   strcoil - coil object
    %   points - n x 3 matrix of points
    %   data - field data
    %   threshold - distance threshold
    % Output:
    %   pairs - p x 3 matrix where each row is [index, wireIndex, distance]
    %   data - field data
    
    % Initialize pairs array
    pairs = [];

    % Define the size of each batch (e.g., 20000 points per batch)
    batchSize = 20000;
    numBatches = ceil(size(points, 1) / batchSize);

    % Process each batch
    for b = 1:numBatches
        % Determine the range of points in this batch
        startIndex = (b - 1) * batchSize + 1;
        endIndex = min(b * batchSize, size(points, 1));
        batchPoints = points(startIndex:endIndex, :);

        % Compute distances only for the current batch
        distances = pdist2(batchPoints, strcoil.Pwire, 'euclidean');

        % Find indices and distances below the threshold
        [pointIndices, wireIndices] = find(distances < threshold);
        relevantDistances = distances(sub2ind(size(distances), pointIndices, wireIndices));

        % Create pairs for this batch
        batchPairs = [startIndex + pointIndices - 1, wireIndices, relevantDistances];
        pairs = [pairs; batchPairs];

        % Find nearby non-singular points for replacement
        singularIndices = unique(startIndex + pointIndices - 1);
        
        for i = 1:length(singularIndices)
            singularPointIndex = singularIndices(i);

            % Find the nearest non-singular point
            validIndices = setdiff(1:size(points, 1), singularIndices);  % Exclude singular points
            nearestPointIndex = knnsearch(points(validIndices, :), points(singularPointIndex, :), 'K', 1);
            nearestPointIndex = validIndices(nearestPointIndex);

            % Set the field data of the singular point to the nearby valid point
            data(singularPointIndex, :) = data(nearestPointIndex, :);
        end
    end
end
