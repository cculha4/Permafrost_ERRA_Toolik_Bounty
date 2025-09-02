function figtRRD_compare_maxRRD(colNums_all, maxRRD_all, maxRRDse_all, labels, workdirfig, printfig)

% Color scheme for June, July, August
colors = [
    227, 74, 51;    % June
    252, 141, 89;   % July
    253, 204, 138   % August
] ./ 255;

% Formatting options
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,2*2};
FS = {'FontSize',10*3,15*3,18*3,21*3,30*3};
UN = {'Units','Normalized','Inches'};

% Layout
axh = 5; axw = 1.5 * axh;
axb = 1.1; axt = 0.5; axl = 1.0; axr = 0.5; ahs = 0.15; cbw = 0.2; ht = 0.05;
fh = axb + axh + 0.15 + ht + axt;
fw = axl + axw + ahs + cbw + axr;

% Create figure
f = figure;
set(f, 'Units', 'Inches', 'Position', [0.7 12 fw fh]);
set(f, 'PaperPosition', [0 0 fw*2.2 fh*2.2], 'PaperSize', [fw fh]);
set(f, 'Color', 'w', 'InvertHardcopy', 'off', 'MenuBar', 'none', 'Resize', 'off', 'Toolbar', 'none');
ax = axes('Units', 'Inches', 'Position', [axl axb axw axh]);

hold on

% Plot each dataset
for i = 1:numel(labels)
    xvals = colNums_all{i};
    yvals = maxRRD_all{i};
    yerr  = maxRRDse_all{i};

    plot(xvals, yvals, '.', 'MarkerSize', 90, 'Color', colors(i,:));
end
for i = 1:numel(labels)
    xvals = colNums_all{i};
    yvals = maxRRD_all{i};
    yerr  = maxRRDse_all{i};

    errorbar(xvals, yvals, yerr, 'LineStyle', 'none', 'Color', colors(i,:), ...
             'LineWidth', 4, 'Marker', '.', 'MarkerSize', 20);
end

% Axes and labels
set(gca, LW{[1,4]}, TL{:}, FS{[1,4]});
xlabel('10-hour antecedent streamflow [mm/h]', TX{:}, FS{[1,4]}, UN{[1,3]});
ylabel('Peak RRD [1/h]', TX{:}, FS{[1,4]}, UN{[1,3]});
title('', TX{:}, FS{[1,4]}, UN{[1,3]});
ax.YAxis.Exponent = -3;

% Legend
legend(labels, 'Location', 'northwest', TX{:}, FS{[1,4]});

% Save
if printfig
    if ~exist(workdirfig, 'dir')
        mkdir(workdirfig);
    end
    cd(workdirfig)
    print(f, '-dpng', '-r200', '-opengl', 'compare_maxRRD_knot', '-loose');
end

end
