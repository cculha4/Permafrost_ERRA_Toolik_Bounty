%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxRRD,maxRRDlgt,RRD,se,lagt,colNums,lagQrange] =  figtRRD_plot_antecedent(name,filename,filestats,workdir,workdirfig,printfig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%ignore extreme knots
ignex = 0;




% Import the data
cd(workdir)


opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["sset_label",	"lwr_lagQ",	"upr_lagQ",	"mean_lagQ",	"tpeak",	"tpeak_se",	"peakht",	"peakht_se",	"width",	"width_se",	"rc",	"rc_se", "nnz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "sset_label", "TrimNonNumeric", true);
opts = setvaropts(opts, "sset_label", "ThousandsSeparator", ",");

% Import the data
hrsimpleknotpeakstats = readtable(filestats, opts);

colNums = hrsimpleknotpeakstats.mean_lagQ;
lagQrange    = [hrsimpleknotpeakstats.lwr_lagQ; max(hrsimpleknotpeakstats.upr_lagQ)];
NOtests = numel(colNums);
colVals = hrsimpleknotpeakstats.mean_lagQ;
colRange = [hrsimpleknotpeakstats.lwr_lagQ; hrsimpleknotpeakstats.upr_lagQ(end)];
maxRRD = hrsimpleknotpeakstats.peakht;
maxRRDse = hrsimpleknotpeakstats.peakht_se;
maxRRDlgt = hrsimpleknotpeakstats.tpeak;

indxRRD = 2:NOtests+1;
indxse  = (NOtests+2):2*NOtests+1;


dat = readtable(filename);

lagt = table2array(dat(:,"lagtime"));
RRD = table2array(dat(:,indxRRD));
se = table2array(dat(:,indxse));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltRRD' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';

if NOtests == 4
    Colors = [
251,180,185
247,104,161
197,27,138
122,1,119]./255;
elseif NOtests == 5
    Colors = [254,235,226
251,180,185
247,104,161
197,27,138
122,1,119]./255;
   
elseif NOtests == 6
    Colors = [254,235,226
252,197,192
250,159,181
247,104,161
197,27,138
122,1,119]./255;
elseif NOtests == 7
    Colors = [254,235,226
252,197,192
250,159,181
247,104,161
221,52,151
174,1,126
122,1,119]./255;
elseif NOtests == 8
    Colors = [252,197,192
212,185,218
201,148,199
250,159,181
247,104,161
221,52,151
174,1,126
122,1,119]./255;
end


% prepare formating options
HA = {'HorizontalAlignment','left','center','right'};
VA = {'VerticalAlignment','bottom','middle','top'};
UN = {'Units','Normalized','Inches'};
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,2*2};
FS = {'FontSize',10*3,15*3,18*3,21*3,30*3};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
LC = {'Color',Colors};


%Plotting profiles
axh = 5;
axw = 1.5*axh;
ahs = 0.15;
avs = 0.15;
axb = 1.1;
axt = 0.5;
axl = 1.0;
axr = 0.5;
cbh = axh; cbw = 0.2; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;



%set figure page
f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

%Plot figure
hold on
for l = 1:NOtests
    
e = errorbar(lagt(1:end)',RRD(1:end,l),se(1:end,l),'-','LineWidth',6,'Color',Colors(l,:));
hold on
e.CapSize = 0;
% Set the error bar color to black
% e.Children.Color = [0 0 0]; % Vertical error bars
end







line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max(max([RRD+se]))],TL{:},FS{[1,5]});
xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]});
ylabel('RRD [1/h]',TX{:},FS{[1,5]},UN{[1,3]});%,'Position',[-2.*axl/3*.7,axh/2]);
title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
for l = 1:NOtests
legendText{l} = strcat(num2str(round(100*colRange(l))/100),'-', num2str(round(100*colRange(l+1))/100), ' mm/h');
end

%legend 
[lgd, hobj, ~, ~] = legend(legendText,TX{:},FS{[1,4]},'Location','northeast');
adjustLegendSize(lgd,hobj,1.05,1.00,10,1);


ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting


%Save figure
if printfig
    cd(workdirfig);
    % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['ltRRD_knots_' filename, '2'];
    
    figname   = str2; %char(strcat(str2(1),str2(2)));
    print(f1,format,resl,rend,figname,'-loose');
end


%set figure page
f2 = figure;
set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f2,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);
hold on
xaxisplot = colNums;
plot(xaxisplot,maxRRD,'.','MarkerSize',50*2,'Color','k')
errorbar(xaxisplot,maxRRD,maxRRDse(1:NOtests),'ok','LineStyle', 'none','MarkerSize',10*2,...
         "MarkerEdgeColor","black",'LineWidth',6)


for jj = 1:NOtests
    plot(xaxisplot(jj),maxRRD(jj),'.','MarkerSize',45*2,'Color',Colors(jj,:))
    hold on
end

% paramsFit = asymfit(xaxisplot([1:4 7:8])',maxRRD([1:4 7:8]));

set(gca, LW{[1,4]},'XLim',[0,max(xaxisplot)*1.1],'Ylim',[0, max(maxRRD+maxRRDse)],TL{:},FS{[1,5]});
% legend(legendText,TX{:},FS{[1,5]},'Location','southeast');
%set axis
xlabel('10-hour antecedent streamflow [mm/h]',TX{:},FS{[1,5]},UN{[1,3]});
ylabel('Peak RRD [1/h]',TX{:},FS{[1,5]},UN{[1,3]});
  title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
ax = gca;  % or use specific axes handle
ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting



%Save figure
if printfig
  cd(workdirfig);
  % set printing options
    % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['maxRRD_knot_', filename,'2'];
    figname   = str2; %char(strcat(str2(1)),strcat(str2(2)));

  format    = '-dpng';
  resl      = '-r200';
  rend      = '-opengl';
%   figname   = char(strcat(str(1)));
  print(f2,format,resl,rend,figname,'-loose');
end
cd(workdir)
