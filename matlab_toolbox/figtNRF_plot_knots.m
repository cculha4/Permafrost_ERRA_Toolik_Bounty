function [maxNRF,maxNRFlgt,NRF,se,lagt] =  figtNRF_plot_knots(name,filename, filestats, knotfilestats, workdir,workdirfig,printfig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Import the data
cd(workdir)

opts = delimitedTextImportOptions("NumVariables", 14);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["setwm_label",	"wtd_meanp",	"pvol",	"tpeak",	"tpeak_se",	"NRF_peakht",	"NRF_peakht_se",	"width",	"width_se",	"rc",	"rc_se",	"rsum",	"rsum_se",	"nnz"];
% opts.VariableNames = ["setbp_label",	"knot",	"knot_pvol",	"tpeak",	"tpeak_se",	"knot_NRF_peakht",	"knot_NRF_peakht_se",	"width",	"width_se",	"rc",	"rc_se",	"knot_rsum",	"knot_rsum_se",	"nnz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "setwm_label", "TrimNonNumeric", true);
opts = setvaropts(opts, "setwm_label", "ThousandsSeparator", ",");

% Import the data
hrsimplepeakstats = readtable(filestats, opts);


opts = delimitedTextImportOptions("NumVariables", 14);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% opts.VariableNames = ["setwm_label",	"wtd_meanp",	"pvol",	"tpeak",	"tpeak_se",	"NRF_peakht",	"NRF_peakht_se",	"width",	"width_se",	"rc",	"rc_se",	"rsum",	"rsum_se",	"nnz"];
opts.VariableNames = ["setbp_label",	"knot",	"knot_pvol",	"tpeak",	"tpeak_se",	"knot_NRF_peakht",	"knot_NRF_peakht_se",	"width",	"width_se",	"rc",	"rc_se",	"knot_rsum",	"knot_rsum_se",	"nnz"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
hrsimpleknotpeakstats = readtable(knotfilestats, opts);

colNums = hrsimpleknotpeakstats.knot;
NOtests = numel(colNums)-1;
colVals = hrsimplepeakstats.wtd_meanp;
% 
%ignore extreme knots
ignex = 0;


dat = readtable(filename);
% Extract the column names
columnNames = dat.Properties.VariableNames;


NOtests = numel(columnNames)-1;
NOtests2 = NOtests/2; 
indxNRF = 2:NOtests2+1;
indxse  = (NOtests2+2):NOtests+1;

NOtestsp = NOtests2-ignex;


lagt = table2array(dat(:,"lagtime"));
NRF = table2array(dat(:,indxNRF));
se = table2array(dat(:,indxse));

maxNRF = max(NRF);
minNRF = min(NRF);
for l = 1:NOtests2
index_lagt = NRF(:,l) ==maxNRF(l);
maxNRFlgt(l) = lagt(index_lagt);
maxNRFse(l) = se(index_lagt,l);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltNRF' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';


if NOtestsp == 3
    Colors = [
        168,221,181;
        67,162,202;
        8,104,172]./255;
    
elseif  NOtestsp == 4
    Colors = [
        168,221,181;
        123,204,196;
        67,162,202;
        8,104,172]./255;
elseif NOtestsp == 5
    Colors = [204,235,197;
        168,221,181;
        123,204,196;
        67,162,202;
        8,104,172]./255;
elseif NOtestsp == 6
    Colors = [240,249,232;
        204,235,197;
        168,221,181;
        123,204,196;
        67,162,202;
        8,104,172]./255;
elseif NOtestsp == 7
    Colors = [240,249,232;
        204,235,197;
        168,221,181;
        123,204,196;
        78,179,211;
        43,140,190;
        8,88,158]./255;
elseif NOtestsp == 8
    Colors = [247,252,240;
        224,243,219;
        204,235,197;
        168,221,181;
        123,204,196;
        78,179,211;
        43,140,190;
        8,88,158]./255;
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
for l = 1:NOtestsp
e=errorbar(lagt(1:end)',NRF(1:end,l),se(1:end,l),'-','LineWidth',6,...
    'Color',Colors(l,:));
hold on
e.CapSize = 0;
end
line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);

set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[min(min([NRF-se])), max(max([NRF+se]))],TL{:},FS{[1,5]});
xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]});
ylabel('NRF  [mm/h]',TX{:},FS{[1,5]},UN{[1,3]});
title(name,TX{:},FS{[1,5]},UN{[1,3]})
colNums = [0 colNums'];
for l = 1:NOtestsp
legendText{l} = strcat(num2str(round(100*colNums(l))/100),'-', num2str(round(100*colNums(l+1))/100), ' mm/h');
end
% legend(legendText,TX{:},FS{[1,5]},'Location','northeast')
[lgd, hobj, ~, ~] = legend(legendText,TX{:},FS{[1,4]},'Location','northeast');
adjustLegendSize(lgd,hobj,1.05,1.00,10,1);

ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting

%Save figure
if printfig
    cd(workdirfig);
     % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['ltNRF_knots_'];
    
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
plot(colVals(1:NOtestsp),maxNRF(1:NOtestsp),'.','MarkerSize',50*2,'Color','k')
errorbar(colVals(1:NOtestsp),maxNRF(1:NOtestsp),maxNRFse(1:NOtestsp),'ok','LineStyle', 'none','MarkerSize',10,...
         "MarkerEdgeColor","black",LW{[1,5]})
[p,S] = polyfit(colVals(1:NOtestsp-1),maxNRF(1:NOtestsp-1),1); 
[y_fit,delta] = polyval(p,colVals(1:NOtestsp-1),S);
% plot(colVals(1:NOtestsp-1),y_fit,'r-',LW{[1,4]})

for jj = 1:NOtestsp
    plot(colVals(jj),maxNRF(jj),'.','MarkerSize',45*2,'Color',Colors(jj,:))
    hold on
end
set(gca, LW{[1,4]},'XLim',[0,max(colVals)*1.2],'Ylim',[0, max(maxNRF+maxNRFse)],TL{:},FS{[1,5]});
% legend(legendText,TX{:},FS{[1,5]},'Location','southeast');
%set axis
xlabel('Rainfall intensity [mm/h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Peak NRF [mm/h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[-axl/2-ahs/2,axh/2]);
ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting  

%Save figure
if printfig
  cd(workdirfig);
  % set printing options
  format    = '-dpng';
  resl      = '-r200';
  rend      = '-opengl';
    str2       = ['maxNRF_knots_'];
    
    figname   = str2; %char(strcat(str2(1),str2(2)));
    print(f2,format,resl,rend,figname,'-loose');
end