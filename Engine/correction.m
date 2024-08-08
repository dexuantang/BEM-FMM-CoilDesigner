function [phi] = correction(direction, UnitPathVector, Pcontour)
    M = 100;
    direction       = cross(direction, UnitPathVector);
    Direction       = repmat(direction, size(Pcontour, 1), 1);
    angle           = zeros(M+1, 1);
    maximumproj     = zeros(M+1, 1);
    for m = 1:M+1
        angle(m) = -pi/4+(m-1)*pi/2/M;    % one pi is enough!
        temp = meshrotate_axis(Pcontour, UnitPathVector, angle(m));
        maximumproj(m) = max(abs(sum(Direction.*temp, 2))); 
    end
    [~, I] = min(maximumproj);
    phi = angle(I);
end