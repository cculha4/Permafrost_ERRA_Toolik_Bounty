%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtQP_plot_UK(filename,workdir,workdirfig,printfig)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

opts = delimitedTextImportOptions("NumVariables", 12);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["shortt", "shortt_1", "short_t_cont_num", "years", "months", "RH", "airtemp", "dewpoint", "snowdepth", "groundwater", "P", "Q"];
opts.VariableTypes = ["datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "shortt", "InputFormat", "yyyy-MM-dd HH:mm");
opts = setvaropts(opts, "shortt_1", "InputFormat", "yyyy-MM-dd HH:mm");

% Import the data
cd(workdir)
dataM = readtable(filename, opts);

P = table2array(dataM(:,"P"));
Q = table2array(dataM(:,"Q"));
t = table2array(dataM(:,"short_t_cont_num"));



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'tQP' };
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
FS = {'FontSize',10,15,18,21,24};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};


%Plotting profiles
axh = 5;
axw = 4*axh;
ahs = 0;%0.15;
avs = 0;%0.15;
axb = 0.7;
axt = 0.5;
axl = 0.8;
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

yyaxis left
plot(t,Q,'-k',LW{[1,end]})
xlabel('t',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Q [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
set(gca,'XLim',[min(t),max(t)],'Ylim',[0, max(Q)],TL{:},FS{[1,4]});

hold on

yyaxis right   
plot(t,P,'-b')
xlabel('t',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Rainfall [mm]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[fw-3*axr/2,axh/2]);
set(gca,'XLim',[min(t),max(t)],'Ylim',[0, max(P)],TL{:},FS{[1,4]});

% 
% ax(2) = axes('Units','Inches','position',[axl*2 axb+axh+2*(avs+ht+axt) axw axh]);
% 
% colororder({'k','b'})
% 
% yyaxis left
% plot(t,Q,'-k',LW{[1,end]})
% xlabel('t',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
% ylabel('Q',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-5*axl/4,axh/2]);
% set(gca,'XLim',[min(t),max(t)],'Ylim',[0, nanmean(Q)],TL{:},FS{[1,4]});
% 
% hold on
% 
% yyaxis right   
% plot(t,P,'-b')
% xlabel('t',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
% ylabel('P',TX{:},FS{[1,4]},UN{[1,3]},'Position',[fw-5*axr/2-axl,axh/2]);
% set(gca,'XLim',[min(t),max(t)],'Ylim',[0, nanmean(P)],TL{:},FS{[1,4]});


%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end

