%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtRRD_plot(name,workdir,workdirfig,printfig,NOinput)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if NOinput == 1
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
cd(workdir)
str = {'1hr_simple_RRD.txt'};
filename=char(strcat(str(1)));
dat = readtable(filename, opts);

lagt = table2array(dat(:,"lagtime"));
RRD = table2array(dat(:,"RRD_P1all"));
se = table2array(dat(:,"se_P1all"));

elseif NOinput == 2
%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["lagtime", "RRD_P1all", "RRD_P2all", "se_P1all","se_P2all"];
opts.VariableTypes = ["double", "double", "double","double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
cd(workdir)
str = {'1hr_simple_RRD.txt'};
filename=char(strcat(str(1)));
dat = readtable(filename, opts);

lagt = table2array(dat(:,"lagtime"));
RRD1 = table2array(dat(:,"RRD_P1all"));
se1 = table2array(dat(:,"se_P1all"));
RRD2 = table2array(dat(:,"RRD_P2all"));
se2 = table2array(dat(:,"se_P2all"));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltRRD' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';


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
% LC = {'Color',color};


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
if NOinput == 1
    plot(lagt,RRD,'Color','black',LW{[1,5]})
    hold on
% errorbar(lagt,RRD,se,'-s','MarkerSize',30,...
%     "Color","blue","MarkerFaceColor",[0.65 0.85 0.90])
e=errorbar(lagt,RRD,se,'-','LineWidth',4,...
    'Color','black');
hold on
e.CapSize = 0;

set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max([RRD+se])],TL{:},FS{[1,5]});

ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting


xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]});
ylabel('RRD [1/h]',TX{:},FS{[1,5]},UN{[1,3]});
title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
elseif NOinput == 2
    plot(lagt,RRD,'Color',[0.65 0.85 0.90],LW{[1,5]})
    hold on
    % errorbar(lagt,RRD1,se1,'-s','MarkerSize',30,...
    % "Color","blue","MarkerFaceColor",[0.65 0.85 0.90])
    errorbar(lagt,RRD1,se,'-','LineWidth',4,...
    'Color','black');
    hold on
e.CapSize = 0;
     set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max(max([RRD1+se1]))],TL{:},FS{[1,5]});
xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Runoff Response [1/h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[-axl/2,axh/2]);
title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
ax = gca;  % or use specific axes handle
ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting


     f2 = figure;
     set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
     set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
     set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
     set(f2,'Resize','off','Toolbar','none');
     ax = axes('Units','Inches','position',[axl axb axw axh]);
     plot(lagt,RRD2,'Color',[252,141,98]./255,LW{[1,5]})
     hold on
     % errorbar(lagt,RRD2,se2,'-s','MarkerSize',30,...
     %     "Color","red","MarkerFaceColor",[252,141,98]./255)
     errorbar(lagt,RRD2,se,'-','LineWidth',4,...
    'Color','red');
     hold on
e.CapSize = 0;
     set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max(max([RRD2+se2]))],TL{:},FS{[1,5]});
     xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Temperature Runoff Response Distribution [$\frac{\mathrm{mm}}{^{\circ}C~\mathrm{h}}$]', TX{:}, FS{[1,5]}, UN{[1,3]}, 'Position', [-axl/2, axh/2]);
title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])

     %Save figure
     if printfig
         cd(workdirfig);
         str2       = {'ltRRD_Temperature' };
         figname   = char(strcat(str2(1)));
         print(f2,format,resl,rend,figname,'-loose');
     end
end
%set axis
        
%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end

