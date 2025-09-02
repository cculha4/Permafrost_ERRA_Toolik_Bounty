
axh = 5; axw = axh;
ahs = 0.15; avs = 0.15;
axb = 1.3; axt = 0.9; axl = 1.7; axr = 1.1;
cbh = axh; cbw = 0.2; ht = 0.05;
fh = axb + axh + avs + ht + axt;
fw = axl + axw + ahs + cbw + axr;


createSquareFig = @(name) ...
    set(figure('Name',name), 'Units','Inches','Position',[0.7 12 fw fh], ...
    'PaperPosition',[0 0 fw*2.2 fh*2.2], 'PaperSize',[fw fh], ...
    'Color','w','InvertHardcopy','off','MenuBar','none','Resize','off','Toolbar','none');


vars = {'DOC', 'TDS', 'SS', 'POC'};
xvars = {'Q'};                           
xlabels = {'Discharge [mm/d]'};
xtags   = {'Q'};
printfig   = true;                     
workdirfig = pwd;
format     = '-dpng'; resl = []; rend = [];


for i = 1:numel(vars)
    v      = vars{i};
    vlabel = sprintf('%s con. [(mg)/(L)]', v);

    for j = 1:numel(xvars)
        xvar = xvars{j};
        xlab = xlabels{j};

        f  = createSquareFig([v ' vs ' xvar]);
        ax = axes('Units','Inches','Position',[axl axb axw axh]);
        hold on

        x_pt = data_ptarmigan.(xvar);
        x_go = data_goose.(xvar);
        y_pt = data_ptarmigan.(v);
        y_go = data_goose.(v);

        
        
        % --- subset to strictly positive x & y values ---
        ok_pt = x_pt>0  & y_pt>0;
        ok_go = x_go>0  & y_go>0;
        
        x_pt2 = x_pt(ok_pt);   y_pt2 = y_pt(ok_pt);
        x_go2 = x_go(ok_go);   y_go2 = y_go(ok_go);

        % scatter points on log-log axes
        h_sc_pt = loglog(x_pt2, y_pt2, '.', 'MarkerSize', 50, 'Color', color_ptarmigan);
        h_sc_go = loglog(x_go2, y_go2, '.', 'MarkerSize', 50, 'Color', color_goose);

        


        % compute Spearman's ρ
        clear rho_pt p_pt rho_go p_go
        [rho_pt, p_pt] = corr(x_pt2, y_pt2, 'Type','Spearman', 'Rows','complete');
        [rho_go, p_go] = corr(x_go2, y_go2, 'Type','Spearman', 'Rows','complete');

        % fit power law in log-log space
        clear coef_pt coef_go yfit_pt yfit_go
        coef_pt = polyfit(log10(x_pt2), log10(y_pt2), 1);
        coef_go = polyfit(log10(x_go2), log10(y_go2), 1);


        xmin = min([x_pt2; x_go2]);
        xmax = max([x_pt2; x_go2]);
        xfit = logspace(log10(xmin), log10(xmax), 100);

        yfit_pt = 10^(coef_pt(2)) .* xfit.^coef_pt(1);
        yfit_go = 10^(coef_go(2)) .* xfit.^coef_go(1);


        % fit lines
        h_fit_pt = loglog(xfit, yfit_pt, 'LineWidth', 3, 'Color', color_ptarmigan);
        h_fit_go = loglog(xfit, yfit_go, 'LineWidth', 3, 'Color', color_goose);


        xlabel(sprintf('$log_{10}$(%s)', xlab), TX{:}, FS{[1,5]}, UN{[1,3]});
        ylabel(sprintf('$log_{10}$(%s)', vlabel), TX{:}, FS{[1,5]}, UN{[1,3]});

        [lgd, hobj, ~, ~] = legend( ...
          [h_sc_pt, h_sc_go, h_fit_pt, h_fit_go], ...
          { 'Ptarmigan data', ...
            'Goose      data'  ...
            sprintf('Ptarmigan fit ($\\rho =$ %.2f)', rho_pt), ...
            sprintf('Goose      fit ($\\rho =$ %.2f)', rho_go)
          }, ...
          'Location','northeast', TX{:}, FS{[1,5]});
        
        adjustLegendSize(lgd,hobj,1.05,1.00,10,1);
        lgd.ItemTokenSize = [50 50];   
        set(gca, TL{:}, LW{[1,4]}, FS{[1,5]});
        set(gca, 'XScale','log', 'YScale','log');
        yl = ylim;                    
        set(gca, 'YLim', [yl(1), yl(2)*1.5]);

        grid off
        hold off

        % optionally save
        if printfig
            cd(workdirfig);
            print(f, format, resl, rend, ['CB_' v '_conc_vs_' xtags{j}], '-loose');
        end
    end
end

