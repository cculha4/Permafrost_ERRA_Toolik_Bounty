%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all

workdir = '~/Documents/git_Research/Permafrost_ERRA/Permafrost_ERRA';
workdirfig = '~/Documents/git_Research/Permafrost_ERRA/Permafrost_ERRA/figures';
cd(workdir)

str = {'vignettes_data.txt'};
filename=char(strcat(str(1)));

opts = delimitedTextImportOptions("NumVariables", 12);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["date_time_UTC1", "hour_ended", "year", "waterYr", "month", "RH_", "airtemp_degC", "TAUT_dewpoint_degC", "snowdepth_cm", "groundwater_cm_below_surface", "P_Erlenbach_mmh", "Q_Erlenbach_mmh"];
opts.VariableTypes = ["datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "date_time_UTC1", "InputFormat", "yyyy-MM-dd HH:mm");
opts = setvaropts(opts, "hour_ended", "InputFormat", "yyyy-MM-dd HH:mm");

% Import the data
vignettesdata = readtable(filename, opts);

P = table2array(vignettesdata(:,"P_Erlenbach_mmh"));
Q = table2array(vignettesdata(:,"Q_Erlenbach_mmh"));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options

% figname   = 'Case3_loss';
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';
printfig  = false;


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


%Plotting profiles
axh = 5;
axw = axh;
ahs = 0.15;
avs = 0.15;
axb = 0.7;
axt = 0.5;
axl = 0.8;
axr = 0.5;
cbh = axh; cbw = 0.2; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;


str_C       = {'Test' };
figname   = char(strcat(str_C(1)));
f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw fh],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);


plot(P,Q,'.k')
       hold on


xlabel('P',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Q',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
set(gca,'XLim',[0,max(P)],'Ylim',[0, max(Q)],TL{:},FS{[1,4]});
        
if printfig
  cd(workdirfig);
    print(f1,format,resl,rend,figname,'-loose');
    % %
end

