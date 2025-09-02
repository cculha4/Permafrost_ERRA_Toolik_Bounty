%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtRRD_plot_DOC(name,workdir_noALD,workdirfig,printfig,str,nameplot)


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["lagtime", "RRD_P1all",  "se_P1all"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";


% Import the data
cd(workdir_noALD)

filename=char(strcat(str(1)));
dat_noALD = readtable(filename, opts);

lagt_noALD = table2array(dat_noALD(:,"lagtime"));
RRD_noALD = table2array(dat_noALD(:,"RRD_P1all"));
se_noALD = table2array(dat_noALD(:,"se_P1all"));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltRRD_Goose' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';


% prepare formating options
HA = {'HorizontalAlignment','left','center','right'};
VA = {'VerticalAlignment','bottom','middle','top'};
UN = {'Units','Normalized','Inches'};
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,2*3};
FS = {'FontSize',10*3,15*3,18*3,21*3,24*4};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};


%Plotting profiles
axh = 5;
axw = 1.5*axh;
ahs = 0.15;
avs = 0.15;
axb = 0.9;
axt = 0.9;
axl = 1.5;
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


errorbar(lagt_noALD,RRD_noALD,se_noALD,'-s','MarkerSize',20,...
"Color",[27,158,119]./255,LW{[1,end]},"MarkerFaceColor",[27,158,119]./255)
    
set(gca, LW{[1,4]},'XLim',[0,max(lagt_noALD)],'Ylim',[0,max([max(RRD_noALD+se_noALD)])],TL{:},FS{[1,6]}); %max([RRD+se])


ax = gca;  % or use specific axes handle
% ax.YAxis.Exponent = -8;  % forces ×10⁻³ formatting




% scale_yaxis(gca);
xlabel('Lag time [d]',TX{:},FS{[1,6]},UN{[1,3]});

ylabel(nameplot,TX{:},FS{[1,6]},UN{[1,3]});
title(name,TX{:},FS{[1,6]},UN{[1,3]});

% [lgd, hobj, ~, ~] = legend('Ptarmigan','Goose',TX{:},FS{[1,4]},'Location','northeast');
% adjustLegendSize(lgd,hobj,1.05,1.00,10,1);

%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end


%set axis
        


