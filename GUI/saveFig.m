function saveFig(parent, filename)
    % Create a temporary figure
    tempFig = figure;
    
    % Copy the content of UIAxes to the temporary figure
    axCopy = copyobj(parent, tempFig);
    
    % Adjust the position to fill the figure
    set(axCopy, 'Position', get(tempFig, 'InnerPosition'));
    
    % Save the figure as a .fig file
    savefig(tempFig, filename);
    
    % Close the temporary figure
    close(tempFig);
end
