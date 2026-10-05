%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxRRD,maxRRDlgt,RRD,se,lagt,colNums] =  figtRRD_plot_temperatures_perc(name,filename,filestats,workdir,workdirfig,printfig)

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
opts.VariableNames = ["sset_label",	"lwr_TempCond",	"upr_TempCond",	"mean_TempCond",	"tpeak",	"tpeak_se",	"peakht",	"peakht_se",	"width",	"width_se",	"rc",	"rc_se", "nnz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "sset_label", "TrimNonNumeric", true);
opts = setvaropts(opts, "sset_label", "ThousandsSeparator", ",");

% Import the data
hrsimpleknotpeakstats = readtable(filestats, opts);

colNums = hrsimpleknotpeakstats.mean_TempCond;
NOtests = numel(colNums);
colVals = hrsimpleknotpeakstats.mean_TempCond;
colRange = [hrsimpleknotpeakstats.lwr_TempCond; hrsimpleknotpeakstats.upr_TempCond(end)];












dat = readtable(filename);

indxRRD = 2:NOtests+1;
indxse  = (NOtests+1):2*NOtests;


lagt = table2array(dat(:,"lagtime"));
RRD = table2array(dat(:,indxRRD));
se = table2array(dat(:,indxse));

maxRRD = max(RRD);
minRRD = min(RRD);
for l = 1:NOtests
index_lagt = RRD(:,l) ==maxRRD(l);
maxRRDlgt(l) = lagt(index_lagt);
maxRRDse(l) = se(index_lagt,l);
end

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
44,123,182;
    171,217,233;
    253,174,97;
    215,25,28]./255;
elseif NOtests == 5
    Colors = [44,123,182;
        171,217,233;
        255,255,191;
        253,174,97;
        215,25,28
]./255;
   
elseif NOtests == 6
    Colors = [69,117,180;
145,191,219;
224,243,248;
254,224,144;
252,141,89;
215,48,39;
]./255;
elseif NOtests == 7
    Colors = [69,117,180;
145,191,219;
224,243,248;
255,255,191;
254,224,144;
252,141,89;
215,48,39;
]./255;
elseif NOtests == 8
    Colors = [
69,117,180
116,173,209
171,217,233
224,243,248
254,224,144
253,174,97
244,109,67
215,48,39]./255;
end


% prepare formating options
HA = {'HorizontalAlignment','left','center','right'};
VA = {'VerticalAlignment','bottom','middle','top'};
UN = {'Units','Normalized','Inches'};
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,2*2};
FS = {'FontSize',10*2,15*2,18*2,21*2,24*2};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
LC = {'Color',Colors};


%Plotting profiles
axh = 5;
axw = 1.25*axh;
ahs = 0.15;
avs = 0.15;
axb = 0.7;
axt = 0.5;
axl = 1.5;
axr = 0.5;
cbh = axh; cbw = 1; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;


%set figure page
f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl*.7 axb axw axh]);

%Plot figure
hold on
for l = 1:NOtests
    
e = errorbar(lagt(1:5:end)',RRD(1:5:end,l),se(1:5:end,l),'-','LineWidth',6,'Color',Colors(l,:));
hold on
e.CapSize = 0;
% Set the error bar color to black
% e.Children.Color = [0 0 0]; % Vertical error bars
end







line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
set(gca,'XLim',[min(lagt),max(lagt)],'Ylim',[0, max(max([RRD+se]))],TL{:},FS{[1,4]});
xlabel('Hour lag',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Runoff Response Distribution [1/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-2.*axl/3*.7,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
for l = 1:NOtests
legendText{l} = strcat(num2str(round(100*colRange(l))/100),'-', num2str(round(100*colRange(l+1))/100), ' $^{\circ}$C');
end
legend(legendText,TX{:},FS{[1,4]},'Location','northeast');

%Save figure
if printfig
    cd(workdirfig);
    % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['ltRRD_Temp_perc_' filename, '2'];
    
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
         "MarkerEdgeColor","black")
for jj = 1:NOtests
    plot(xaxisplot(jj),maxRRD(jj),'.','MarkerSize',45*2,'Color',Colors(jj,:))
    hold on
end

% paramsFit = asymfit(xaxisplot([1:4 7:8])',maxRRD([1:4 7:8]));

set(gca,'XLim',[0,max(xaxisplot)*1.1],'Ylim',[0, max(maxRRD+maxRRDse)],TL{:},FS{[1,5]});
% legend(legendText,TX{:},FS{[1,5]},'Location','southeast');
%set axis
xlabel('Temperature [$^{\circ}$C]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Peak Runoff Response Distribution [1/hr]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[-2.*axl/3,axh/2]);
  title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])


%Save figure
if printfig
  cd(workdirfig);
  % set printing options
    % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['maxRRD_Temp_perc_', filename,'2'];
    figname   = str2; %char(strcat(str2(1)),strcat(str2(2)));

  format    = '-dpng';
  resl      = '-r200';
  rend      = '-opengl';
%   figname   = char(strcat(str(1)));
  print(f2,format,resl,rend,figname,'-loose');
end
cd(workdir)