% function [pairs, data] = singularity(strcoil, points, data, threshold)
%     % Find points that are too close to the coil wires
%     % Inputs:
%     %   strcoil - coil object
%     %   points - n x 3 matrix of points
%     %   data - field data
%     %   threshold - distance threshold
%     % Output:
%     %   pairs - p x 2 matrix where each row is [index, distance]
%     %   data - field data
% 
%     % Compute pairwise distances between points in the coil and points
%     distances = pdist2(points, strcoil.Pwire, 'euclidean');
% 
%     % Find indices where distances are below the threshold
%     [pointIndices, wireIndices] = find(distances < threshold);
% 
%     % Create pairs array
%     pairs = [pointIndices, wireIndices, distances(sub2ind(size(distances), pointIndices, wireIndices))];
% 
%     % Set field to zero for points within the threshold
%     data(unique(pointIndices), :) = 0;
% end

function [pairs, data] = singularity(strcoil, points, data, threshold)
    % Find points that are too close to the coil wires
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

    % Define the size of each batch (e.g., 1000 points per batch)
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

        % Set field data to zero where necessary
        data(unique(startIndex + pointIndices - 1), :) = 0;
    end
end

