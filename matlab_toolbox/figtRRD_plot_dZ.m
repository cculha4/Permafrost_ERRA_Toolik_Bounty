%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtRRD_plot_dZ(name,workdir,workdirfig,printfig,NOinput,str,nameplot,colors_)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% nameplot 'Carbon Runoff Response Distribution [$\frac{\mathrm{mg}}{\mathrm{mm}^4}$]'
%% 'Thawing - Carbon Runoff Response Distribution [$\frac{\mathrm{mg}}{\mathrm{mm}^4}$]'
%% 'Rainfall - Carbon Runoff Response Distribution [$\frac{\mathrm{mg}}{\mathrm{mm}^4}$]'
%% 'Thawing - River Runoff Response Distribution [$\frac{1}{\mathrm{hr}$]'
%% Colors_ (if NOinput is 1) 1 blue, 2 red, 3 black, 4 black with orange filling
%% if NOinput is 2, colors_ is 1 blue/red

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
% str = {'Rresults/1hr_simple_RRD.txt'};
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
FS = {'FontSize',10*3,15*3,18*3,21*3,24*3};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};


%Plotting profiles
axh = 5;
axw = 1.5*axh;
ahs = 0.15;
avs = 0.15;
axb = 1.5;
axt = 0.9;
axl = 1.50;
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
    if colors_ == 1
        errorbar(lagt,RRD,se,'-s','MarkerSize',10,...
    "Color","blue",'LineWidth',10)%,"MarkerFaceColor",[252,141,98]./255)
    elseif colors_ ==2
        errorbar(lagt,RRD,se,'-s','MarkerSize',10,...
    "Color","red",'LineWidth',10)%,"MarkerFaceColor",[252,141,98]./255)
    elseif colors_==3
        errorbar(lagt,RRD,se,'-s','MarkerSize',10,...
    "Color","black",'LineWidth',10)%,"MarkerFaceColor",[252,141,98]./255)
    elseif colors_ ==4
    errorbar(lagt,RRD,se,'-s','MarkerSize',10,...
    "Color","black",'LineWidth',10,"MarkerFaceColor",[252,141,98]./255)
    end
% line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);

set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0,max(RRD+se)],TL{:},FS{[1,5]}); %max([RRD+se])


ax = gca;  % or use specific axes handle
ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting




% scale_yaxis(gca);
xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]});

ylabel(nameplot,TX{:},FS{[1,5]},UN{[1,3]});
title(name,TX{:},FS{[1,5]},UN{[1,3]});

%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end


elseif NOinput == 2
    if colors_ == 1
        errorbar(lagt,RRD1,se1,'-s','MarkerSize',50,...
             "Color",[43,140,190]./255,'LineWidth',10,"MarkerFaceColor",[43,140,190]./255)
        hold on
        errorbar(lagt,RRD2,se2,'-s','MarkerSize',50,...
         "Color",[252,141,98]./255,'LineWidth',10,"MarkerFaceColor",[252,141,98]./255)

        h(1) = plot(nan, nan, '.','Color',[43,140,190]./255, 'MarkerSize', 100, 'DisplayName', 'Rainfall');
        h(2) = plot(nan, nan, '.', 'Color', [252,141,98]./255, 'MarkerSize', 100, 'DisplayName', 'Thawing');
        legend(h,...
            TX{:},FS{[1,5]},UN{[1,3]},'Location','NorthEast');
    else
    plot(lagt,RRD1,'-s','MarkerSize',50,...
         "Color",[43,140,190]./255,'LineWidth',10,"MarkerFaceColor",[43,140,190]./255)
    end
    set(gca,LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max(max([RRD1+se1 RRD2+se2]))],TL{:},FS{[1,5]});
    % scale_yaxis(gca);
    xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
    % ylabel(nameplot{1},TX{:},FS{[1,5]},UN{[1,3]})%,'Position',[-axl/2,axh/2]);
    ylabel('RRD [h$^{-1}$]', TX{:},FS{[1,5]},UN{[1,3]})%,'Position',[-axl/2,axh/2]);
    title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
    ax.YAxis.Exponent = -3;
% scale_yaxis();

    % line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
    box off
    %  f2 = figure;
    %  set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
    %  set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
    %  set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
    %  set(f2,'Resize','off','Toolbar','none');
    %  ax = axes('Units','Inches','position',[axl axb axw axh]);
    %  if colors_ == 1
    %  errorbar(lagt,RRD2,se2,'-s','MarkerSize',50,...
    %      "Color",[252,141,98]./255,'LineWidth',10,"MarkerFaceColor",[252,141,98]./255)
    %  else
    %          plot(lagt,RRD2,'-s','MarkerSize',50,...
    %      "Color",[227,74,51]./255,'LineWidth',10,"MarkerFaceColor",[227,74,51]./255)
    %  end
    %  % scale_yaxis(gca);
    %  set(gca, LW{[1,4]},'XLim',[0,max(lagt)],'Ylim',[0, max(max([RRD1+se1 RRD2+se2]))],TL{:},FS{[1,5]});
    %  xlabel('lag time [h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
    % ylabel(nameplot{2}, TX{:}, FS{[1,5]}, UN{[1,3]})%, 'Position', [-axl/2, axh/2]);
    % title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
    % % scale_yaxis();
    % line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
    % box off
     %Save figure
     if printfig
         cd(workdirfig);
         str2       = {'ltRRD' };
         figname   = char(strcat(str2(1)));
         print(f1,format,resl,rend,figname,'-loose');
         % str2       = {'ltRRD_Rainfall' };
         % figname   = char(strcat(str2(1)));
         % print(f1,format,resl,rend,figname,'-loose');
     end
end
%set axis
        


