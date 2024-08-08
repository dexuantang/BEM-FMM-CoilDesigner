function TR = connectivitySurgery(TR, max_iterations, edge_threshold)
    % Parameters:
    % TR - input triangulation object
    % max_iterations - maximum number of iterations for surgery
    % edge_threshold - threshold for edge length to consider for collapse
    
    % Extract vertices and connectivity list
    vertices = TR.Points;
    triangles = TR.ConnectivityList;
    
    % Perform connectivity surgery
    for iter = 1:max_iterations
        % Step 1: Edge Collapse
        edges = TR.edges;
        for e = 1:size(edges, 1)
            v1 = edges(e, 1);
            v2 = edges(e, 2);
            
            % Compute the length of the edge
            edge_length = norm(vertices(v1, :) - vertices(v2, :));
            
            % If the edge length is below the threshold, collapse the edge
            if edge_length < edge_threshold
                disp(e);
                TR = edgeCollapse(TR, [v1, v2]);
                vertices = TR.Points;
                triangles = TR.ConnectivityList;
            end
        end
        
        % Step 2: Vertex Pair Contraction
        % Get the updated edges after edge collapse
        edges = TR.edges;
        for e = 1:size(edges, 1)
            v1 = edges(e, 1);
            v2 = edges(e, 2);
            
            % Compute the distance between the vertex pair
            distance = norm(vertices(v1, :) - vertices(v2, :));
            
            % Contract vertex pairs (optional based on criteria)
            % Here we contract vertex pairs with small distances
            if distance < edge_threshold
                TR = vertexPairContraction(TR, v1, v2);
                vertices = TR.Points;
                triangles = TR.ConnectivityList;
            end
        end
    end
end

function TR = edgeCollapse(TR, edge)
    % Extract vertices and connectivity list
    vertices = TR.Points;
    triangles = TR.ConnectivityList;
    
    % Get the indices of the two vertices forming the edge
    v1 = edge(1);
    v2 = edge(2);
    
    % Compute the new vertex position as the midpoint of v1 and v2
    newVertex = (vertices(v1, :) + vertices(v2, :)) / 2;
    
    % Add the new vertex to the vertices list
    vertices = [vertices; newVertex];
    newVertexIndex = size(vertices, 1);
    
    % Update the connectivity list to use the new vertex
    triangles(triangles == v1 | triangles == v2) = newVertexIndex;
    
    % Remove redundant faces and update the triangulation
     TR = triangulation(unique(triangles, 'rows'), vertices);
end

function TR = vertexPairContraction(TR, v1, v2)
    % Extract vertices and connectivity list
    vertices = TR.Points;
    triangles = TR.ConnectivityList;
    
    % Compute the new vertex position as the midpoint of v1 and v2
    newVertex = (vertices(v1, :) + vertices(v2, :)) / 2;
    
    % Add the new vertex to the vertices list
    vertices = [vertices; newVertex];
    newVertexIndex = size(vertices, 1);
    
    % Update the connectivity list to use the new vertex
    triangles(triangles == v1 | triangles == v2) = newVertexIndex;
    
    % Remove redundant faces and update the triangulation
    TR = triangulation(unique(triangles, 'rows'), vertices);
end


