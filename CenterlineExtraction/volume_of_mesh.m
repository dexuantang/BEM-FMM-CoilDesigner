function volume = volume_of_mesh(TR)
% Function that calculate the signed volume of a mesh
% Input:
%   TR - Triangular object
% Output:
%   volume - Volume of the mesh
    P = TR.Points;
    t = TR.ConnectivityList;
    volume = 0;
    for n = 1:size(t, 1)
        tri = t(n, :);
        v1 = P(tri(1), :);
        v2 = P(tri(2), :);
        v3 = P(tri(3), :);
        volume = volume + dot(v1, cross(v2, v3)) / 6;
    end
    volume = abs(volume);
end