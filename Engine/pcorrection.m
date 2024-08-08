function [phi] = pcorrection(direction, UnitPathVector, rP)
    % Provides a correction angle phi (0 to pi) by calculating the angle 
    % between the direction vector and the vector formed by the two reference points.
    direction       = cross(direction, UnitPathVector);
    rPV = [(rP(1,1)-rP(2,1)) (rP(1,2)-rP(2,2)) (rP(1,3)-rP(2,3))];
    rPV = rPV /norm(rPV);
    x = cross(direction,rPV);
    c = sign(dot(x,UnitPathVector)) * norm(x);
    phi = atan2(c,dot(direction,rPV));
end