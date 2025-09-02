function f = yearsplots(x,y,years,error,xla,yla,tit,labelson, fittingyes)



% prepare formating options
HA = {'HorizontalAlignment','left','center','right'};
VA = {'VerticalAlignment','bottom','middle','top'};
UN = {'Units','Normalized','Inches'};
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,2};
FS = {'FontSize',10,15,18,21,24};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};
Colors = [203,201,226;
158,154,200;
106,81,163;
186,228,179;
116,196,118;
35,139,69;
253,190,133;
253,141,60;
217,71,1;
189,215,231;
107,174,214;
33,113,181
28,144,153]./255;

%Plotting profiles
axh = 5;
axw = 1.5*axh;
ahs = 0.15;
avs = 0.15;
axb = 0.7;
axt = 0.5;
axl = 1.0;
axr = 0.5;
cbh = axh; cbw = 0.2; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;


% % Create new figure
% f = figure;

h = errorbar(x,y,error,'.k','MarkerSize', 40);
% Exclude the error bars from the legend
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
% Plot vector against leverage values
for ll = 1:numel(years)
plot(x(ll), y(ll), '.','MarkerSize',35,'Color',Colors(ll,:));
hold on
end

xlabel(xla,TX{:},FS{[1,4]},UN{[1,3]})
ylabel(yla,TX{:},FS{[1,3]},UN{[1,3]})
% title(tit,TX{:},FS{[1,4]},UN{[1,3]})
if labelson == 1
legend(string(years'),TX{:},FS{[1,4]},UN{[1,3]},'Location','eastoutside')

end
set(gca,LW{[1,4]},TL{:},FS{[1,4]});
if fittingyes == 1
    % calculate the line of best fit coefficients
    xx = x(~isnan(x) & ~isnan(y));
    yy = y(~isnan(x) & ~isnan(y));
    p = polyfit(xx,yy,1); % 1 is the degree of the polynomial fit (linear in this case)

    % evaluate the line of best fit at each x-value
    yfit = polyval(p,xx);

    % plot the line of best fit on top of the data
    hold on;
    plot(xx,yfit,'r','LineWidth',3);
    if labelson == 1
        [m, n] = size(years);
        if m>n
             legend([string(years'),'Best fit'],TX{:},FS{[1,4]},UN{[1,3]},'Location','eastoutside')
        else
        legend([string(years),'Best fit'],TX{:},FS{[1,4]},UN{[1,3]},'Location','eastoutside')
        end
    end
end