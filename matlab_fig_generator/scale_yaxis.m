function scale_yaxis(hAx)
    % hAx is the handle to the axes object.
    if nargin < 1
        hAx = gca; % Default to current axes if no input is provided.
    end

    % Get current y-axis limits and ticks
    yticks = hAx.YTick;
    ylims = hAx.YLim;

    % Determine the scale factor based on the maximum y-limit
    max_val = max(ylims);
    exponent = floor(log10(max_val));
    scaleFactor = 10^exponent;

    % Update y-ticks and labels
    newTicks = yticks / scaleFactor;
    newTickPositions = hAx.YTick / scaleFactor;

    % Update y-ticks and labels
    % hAx.YTick = newTickPositions;
    % hAx.YTick = newTicks;
    hAx.YTickLabel = arrayfun(@num2str, newTicks, 'UniformOutput', false);
    % hAx.YLabel.String = sprintf('\\times10^{%d}', exponent);
    string = sprintf('$\\times10^{%d}$',exponent);
    text(min(hAx.XLim)*0.9, max(hAx.YLim), string, 'FontSize',24,'Interpreter','Latex');
    hAx.YAxis.Visible = 'on';  % Ensure the y-axis is visible
    % Update grid lines if necessary
    % grid on;
end
