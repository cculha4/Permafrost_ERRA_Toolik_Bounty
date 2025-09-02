%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtRRD_stb_ALD(name,workdir,workdirfig,printfig,NOinput,str_stb,str_ALD)

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

filename_stb=char(strcat(str_stb(1)));
dat = readtable(filename_stb, opts);

lagt_stb = table2array(dat(:,"lagtime"));
RRD_stb = table2array(dat(:,"RRD_P1all"));
se_stb = table2array(dat(:,"se_P1all"));


filename_ALD=char(strcat(str_ALD(1)));
dat = readtable(filename_ALD, opts);

lagt_ALD = table2array(dat(:,"lagtime"));
RRD_ALD = table2array(dat(:,"RRD_P1all"));
se_ALD = table2array(dat(:,"se_P1all"));

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
filename_stb=char(strcat(str_stb(1)));
dat = readtable(filename_stb, opts);

lagt_stb = table2array(dat(:,"lagtime"));
RRD1_stb = table2array(dat(:,"RRD_P1all"));
se1_stb = table2array(dat(:,"se_P1all"));
RRD2_stb = table2array(dat(:,"RRD_P2all"));
se2_stb = table2array(dat(:,"se_P2all"));


% str = {'Rresults/1hr_simple_RRD.txt'};
filename_ALD=char(strcat(str_ALD(1)));
dat = readtable(filename_ALD, opts);

lagt_ALD = table2array(dat(:,"lagtime"));
RRD1_ALD = table2array(dat(:,"RRD_P1all"));
se1_ALD = table2array(dat(:,"se_P1all"));
RRD2_ALD = table2array(dat(:,"RRD_P2all"));
se2_ALD = table2array(dat(:,"se_P2all"));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltRRD_ALD' };
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
FS = {'FontSize',10*3,15*3,18*3,21*3,30*3};
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
errorbar(lagt_stb,RRD_stb,se_stb,'-s','MarkerSize',30,...
    "Color",[166,189,219]./255,LW{[1,5]},"MarkerFaceColor",[166,189,219]./255)
errorbar(lagt_ALD,RRD_ALD,se_ALD,'-s','MarkerSize',30,...
    "Color",[28,144,153]./255,LW{[1,5]},"MarkerFaceColor",[28,144,153]./255)
set(gca, LW{[1,4]},'XLim',[0,max(lagt_stb)],'Ylim',[0, .055],TL{:},FS{[1,5]});
ax = gca;  % or use specific axes handle
ax.YAxis.Exponent = -3;  % forces ×10⁻³ formatting

xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]});
ylabel('RRD [1/h]',TX{:},FS{[1,5]},UN{[1,3]});%,'Position',[-axl/2,axh/2]);
title(name,TX{:},FS{[1,5]},UN{[1,3]})
[lgd, hobj, ~, ~] = legend('2012-2021', '2007-2011',TX{:},FS{[1,5]},UN{[1,3]});
adjustLegendSize(lgd,hobj,1.05,1.00,10,1);
 
 % legend('2012-2021', '2007-2011',TX{:},FS{[1,5]},UN{[1,3]})
% line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);

%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end


elseif NOinput == 2
    errorbar(lagt_stb,RRD1_stb,se1_stb,'-s','MarkerSize',30,...
        "Color",[166,189,219]./255,'LineWidth',10,"MarkerFaceColor",[166,189,219]./255)
    hold on
    errorbar(lagt_ALD,RRD1_ALD,se1_ALD,'-s','MarkerSize',30,...
        "Color",[28,144,153]./255,'LineWidth',10,"MarkerFaceColor",[28,144,153]./255)
    % set(gca,'XLim',[min(lagt_ALD),max(lagt_ALD)],'Ylim',[min(min([RRD1_stb-se1_stb; RRD1_ALD-se1_ALD])), max(max([RRD1_stb+se1_stb; RRD1_ALD+se1_ALD]))],TL{:},FS{[1,5]});
    xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
    ylabel('RRD - rainfall [$\frac{1}{\mathrm{h}}$]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[-axl/2,axh/2]);
    title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
    % legend('Stable: 2012-2021', 'Active ALD: 2007-2011',TX{:},FS{[1,5]},UN{[1,3]})
    h(1) = plot(nan, nan, '.','Color',[166,189,219]./255, 'MarkerSize', 80, 'DisplayName', '2012-2021');
    h(2) = plot(nan, nan, '.', 'Color', [28,144,153]./255, 'MarkerSize', 80, 'DisplayName', '2007-2011');
    legend(h,...
        TX{:},FS{[1,5]},UN{[1,3]},'Location','NorthEast');
    % legend('2012-2021', '2007-2011',TX{:},FS{[1,5]},UN{[1,3]})
    % line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
    ax = gca;  % or use specific axes handle
    ax.YAxis.Exponent = -2;  % forces ×10⁻³ formatting

    set(gca, LW{[1,4]},'XLim',[0,max(lagt_ALD)],'YLim',[0,max(max([RRD1_stb+se1_stb; RRD1_ALD+se1_ALD]))], TL{:},FS{[1,5]});



    f2 = figure;
    set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
    set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
    set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
    set(f2,'Resize','off','Toolbar','none');
    ax = axes('Units','Inches','position',[axl axb axw axh]);

    hold on
    errorbar(lagt_stb,RRD2_stb,se2_stb,'-s','MarkerSize',30,...
        "Color",[253,187,132]./255,'LineWidth',10,"MarkerFaceColor",[253,187,132]./255)
    errorbar(lagt_ALD,RRD2_ALD,se2_ALD,'-s','MarkerSize',30,...
        "Color",[227,74,51]./255,'LineWidth',10,"MarkerFaceColor",[227,74,51]./255)
    % set(gca,'XLim',[min(lagt_stb),max(lagt_stb)],'Ylim',[min(min([RRD2_stb-se2_stb; RRD2_ALD-se2_ALD]))/3, max(max([RRD2_ALD+se2_ALD; RRD2_ALD+se2_ALD]))],TL{:},FS{[1,5]});
    xlabel('Lag time [h]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
    ylabel('RRD - thawing [$\frac{1}{\mathrm{h}}$]', TX{:}, FS{[1,5]}, UN{[1,3]}, 'Position', [-axl/2, axh/2]);
    title(name,TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
    % line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
    h(1) = plot(nan, nan, '.','Color',[253,187,132]./255, 'MarkerSize', 80, 'DisplayName', '2012-2021'); %'Stable: 2012-2021');
    h(2) = plot(nan, nan, '.', 'Color', [227,74,51]./255, 'MarkerSize', 80, 'DisplayName', '2007-2011'); %'Active ALD: 2007-2011');
    legend(h,...
        TX{:},FS{[1,5]},UN{[1,3]},'Location','NorthEast');
    % legend('Stable: 2012-2021', 'Active ALD: 2007-2011',TX{:},FS{[1,5]},UN{[1,3]})
    ax = gca;  % or use specific axes handle
    ax.YAxis.Exponent = -2;  % forces ×10⁻³ formatting
        set(gca, LW{[1,4]},'XLim',[0,max(lagt_ALD)],'YLim',[0,max(max([RRD2_ALD+se2_ALD; RRD2_ALD+se2_ALD]))], TL{:},FS{[1,5]});



    %Save figure
     if printfig
         cd(workdirfig);
         str2       = {'ltRRD_Thaw_ALD' };
         figname   = char(strcat(str2(1)));
         print(f2,format,resl,rend,figname,'-loose');
         str2       = {'ltRRD_Rainfall_ALD' };
         figname   = char(strcat(str2(1)));
         print(f1,format,resl,rend,figname,'-loose');
     end
end
%set axis
        
