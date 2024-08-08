function [] = display_GND(parent,Pwire)
    text(parent, Pwire(end,1), Pwire(end,2), (Pwire(end,3)+0.001),'-', 'FontSize', 20, 'Color', 'blue');
    text(parent, Pwire(1,1), Pwire(1,2), (Pwire(1,3)+0.001),'+', 'FontSize', 20, 'Color', 'red');
end

