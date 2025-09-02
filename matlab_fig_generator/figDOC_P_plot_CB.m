function f1 = figDOC_P_plot_CB(name,workdir,workdirfig,printfig,str)





%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["timestep", "time", "weight", "P", "Q", "Qfitted", "Qresidual"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
cd(workdir)

filename=char(strcat(str(1)));
dat = readtable(filename, opts);

t = table2array(dat(:,"time"));
P = table2array(dat(:,"P"));
DOC = table2array(dat(:,"Q"));






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'DOCP' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';



% prepare formating options
HA = {'HorizontalAlignment','left','center','right'};
VA = {'VerticalAlignment','bottom','middle','top'};
UN = {'Units','Normalized','Inches'};
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,2};
FS = {'FontSize',10*3,15*3,18*3,21*3,30*3};
MS = {'MarkerSize',6,8,35};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};


%Plotting profiles
axh = 5;
axw = axh;
ahs = 0.15;
avs = 0.15;
axb = 1.;
axt = 0.5;
axl = 1.5;
axr = axl;
cbh = axh; cbw = 0; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;




f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw 2*fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax(1) = axes('Units','Inches','position',[axl axb+avs axw axh]);
% set(f1,'Units','Inches','Position',[0.7 12 fw fh*2]);
% ax(1) = axes('Units','Inches','position',[axl*2 axb+avs axw axh]);

colororder({'k','b'})


hold on

yyaxis right   
plot(t,P,'-b',LW{[1,end]})
xlabel('t',TX{:},FS{[1,5]},UN{[1,3]});
ylabel('Rainfall [mm/day]',TX{:},FS{[1,5]},UN{[1,3]});
set(gca,'XLim',[min(t),max(t)],'Ylim',[0, max(P)],TL{:},FS{[1,5]});


yyaxis left
plot(t,DOC,'.',MS{[1,end]},LW{[1,end]})
xlabel('t',TX{:},FS{[1,4]},UN{[1,3]});
ylabel(name,TX{:},FS{[1,5]},UN{[1,3]});
set(gca,'XLim',[min(t),max(t)],'Ylim',[0, max(DOC)],TL{:},FS{[1,5]});

title(name,TX{:},FS{[1,5]},UN{[1,3]})
%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('timeseries',str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end

f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw 2*fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax(1) = axes('Units','Inches','position',[axl axb+avs axw axh]);

plot(P,DOC,'.b','MarkerSize',25)
ylabel('DOC [mg/L]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
xlabel('Rainfall [mm]',TX{:},FS{[1,4]},UN{[1,3]});
set(gca,'XLim',[min(P),max(P)],'Ylim',[min(DOC), max(DOC)],TL{:},FS{[1,4]});
title(name,TX{:},FS{[1,4]},UN{[1,3]})

%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end
