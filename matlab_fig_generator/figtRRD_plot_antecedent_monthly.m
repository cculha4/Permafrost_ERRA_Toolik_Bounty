function [maxRRD_all, maxRRDlgt_all, maxRRDse_all, RRD_all, se_all, lagt_all, colNums_all, lagQrange_all] = ...
    figtRRD_plot_antecedent_monthly(name, filename, filestats, workdir, workdirfig, printfig)

% Preallocate output cell arrays
N = numel(filename);
maxRRD_all = cell(1,N);
maxRRDlgt_all = cell(1,N);
maxRRDse_all = cell(1,N);
RRD_all = cell(1,N);
se_all = cell(1,N);
lagt_all = cell(1,N);
colNums_all = cell(1,N);
lagQrange_all = cell(1,N);

for k = 1:N
    %% Set current file inputs
    file = filename{k};
    stat = filestats{k};
    titletext = name{k};

    %% Read stats file
    cd(workdir)
    opts = delimitedTextImportOptions("NumVariables", 13);
    opts.DataLines = [2, Inf];
    opts.Delimiter = "\t";
    opts.VariableNames = ["sset_label","lwr_lagQ","upr_lagQ","mean_lagQ","tpeak","tpeak_se",...
                          "peakht","peakht_se","width","width_se","rc","rc_se","nnz"];
    opts.VariableTypes = repmat("double",1,13);
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    hrsimpleknotpeakstats = readtable(stat, opts);

    colNums = hrsimpleknotpeakstats.mean_lagQ;
    lagQrange = [hrsimpleknotpeakstats.lwr_lagQ; max(hrsimpleknotpeakstats.upr_lagQ)];
    NOtests = numel(colNums);
    colRange = [hrsimpleknotpeakstats.lwr_lagQ; hrsimpleknotpeakstats.upr_lagQ(end)];
    maxRRD = hrsimpleknotpeakstats.peakht;
    maxRRDse = hrsimpleknotpeakstats.peakht_se;
    maxRRDlgt = hrsimpleknotpeakstats.tpeak;

    indxRRD = 2:NOtests+1;
    indxse  = (NOtests+2):2*NOtests+1;

    %% Read data file
    dat = readtable(file);
    lagt = table2array(dat(:,"lagtime"));
    RRD = table2array(dat(:,indxRRD));
    se = table2array(dat(:,indxse));

    %% Store outputs
    maxRRD_all{k} = maxRRD;
    maxRRDlgt_all{k} = maxRRDlgt;
    maxRRDse_all{k} = maxRRDse;
    RRD_all{k} = RRD;
    se_all{k} = se;
    lagt_all{k} = lagt;
    colNums_all{k} = colNums;
    lagQrange_all{k} = lagQrange;

    %% Plotting Colors
    switch NOtests
        case 4
            Colors = [251,180,185; 247,104,161; 197,27,138; 122,1,119]/255;
        case 5
            Colors = [254,235,226; 251,180,185; 247,104,161; 197,27,138; 122,1,119]/255;
        case 6
            Colors = [254,235,226; 252,197,192; 250,159,181; 247,104,161; 197,27,138; 122,1,119]/255;
        case 7
            Colors = [254,235,226; 252,197,192; 250,159,181; 247,104,161; 221,52,151; 174,1,126; 122,1,119]/255;
        case 8
            Colors = [252,197,192; 212,185,218; 201,148,199; 250,159,181; 247,104,161; 221,52,151; 174,1,126; 122,1,119]/255;
        otherwise
            Colors = lines(NOtests);
    end

    %% Formatting options
    HA = {'HorizontalAlignment','left','center','right'};
    VA = {'VerticalAlignment','bottom','middle','top'};
    UN = {'Units','Normalized','Inches'};
    TX = {'Interpreter','Latex'};
    TL = {'TickLabelInterpreter','Latex'};
    LW = {'LineWidth',1,1.25,1.5,2*2};
    FS = {'FontSize',10*3,15*3,18*3,21*3,30*3};
    MS = {'MarkerSize',6,8,12};

    %% Layout
    axh = 5; axw = 1.5*axh;
    ahs = 0.15; avs = 0.15;
    axb = 1.1; axt = 0.5; axl = 1.0; axr = 0.5;
    cbh = axh; cbw = 0.2; ht = 0.05;
    fh = axb + axh + avs + ht + axt;
    fw = axl + axw + ahs + cbw + axr;

    %% First Figure – RRD vs Lag
    f1 = figure;
    set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
    set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
    set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
    set(f1,'Resize','off','Toolbar','none');
    ax = axes('Units','Inches','position',[axl axb axw axh]);

    hold on
    for l = 1:NOtests
        e = errorbar(lagt(1:end)', RRD(1:end,l), se(1:end,l), '-', ...
            'LineWidth', 6, 'Color', Colors(l,:));
        e.CapSize = 0;
    end
    line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
    set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max(max(RRD+se))],TL{:},FS{[1,5]});
    xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]});
    ylabel('RRD [1/h]',TX{:},FS{[1,5]},UN{[1,3]});
    title(titletext,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh]);
    for l = 1:NOtests
        legendText{l} = sprintf('%.2f–%.2f mm/h', colRange(l), colRange(l+1));
    end
    [lgd, hobj, ~, ~] = legend(legendText,TX{:},FS{[1,4]},'Location','northeast');
    adjustLegendSize(lgd,hobj,1.05,1.00,10,1);
    ax.YAxis.Exponent = -3;

    %% Save first figure
    if printfig
        cd(workdirfig);
        fileclean = erase(file, {'1hr_simple_', '.txt'});
        figname1 = ['ltRRD_knots_' fileclean];
        format = '-dpng'; resl = '-r200'; rend = '-opengl';
        print(f1, format, resl, rend, figname1, '-loose');
    end

    %% Second Figure – Max RRD vs Flow
    f2 = figure;
    set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
    set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
    set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
    set(f2,'Resize','off','Toolbar','none');
    ax = axes('Units','Inches','position',[axl axb axw axh]);

    hold on
    xaxisplot = colNums;
    plot(xaxisplot, maxRRD, '.', 'MarkerSize', 100, 'Color', 'k');
    errorbar(xaxisplot, maxRRD, maxRRDse(1:NOtests), 'ok', 'LineStyle','none', ...
             'MarkerEdgeColor','black', 'LineWidth', 6, 'MarkerSize', 20);
    for jj = 1:NOtests
        plot(xaxisplot(jj), maxRRD(jj), '.', 'MarkerSize', 90, 'Color', Colors(jj,:));
    end
    set(gca, LW{[1,4]}, 'XLim', [0, max(xaxisplot)*1.1], 'Ylim', [0, max(maxRRD+maxRRDse)], ...
        TL{:}, FS{[1,5]});
    xlabel('10-hour antecedent streamflow [mm/h]',TX{:},FS{[1,5]},UN{[1,3]});
    ylabel('Peak RRD [1/h]',TX{:},FS{[1,5]},UN{[1,3]});
    title(titletext,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh]);
    ax.YAxis.Exponent = -3;

    %% Save second figure
    if printfig
        cd(workdirfig);
        figname2 = ['maxRRD_knot_' fileclean];
        print(f2, format, resl, rend, figname2, '-loose');
    end

end  % End of loop

cd(workdir);
end
