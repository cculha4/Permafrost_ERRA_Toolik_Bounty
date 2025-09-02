%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtRRD_stb_ALD_carbon(name,workdir,workdirfig,printfig,NOinput,str_stb,str_ALD,maxy)

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
if exist(filename_stb,'file')==2
    dat = readtable(filename_stb, opts);

    lagt_stb = table2array(dat(:,"lagtime"));
    RRD_stb = table2array(dat(:,"RRD_P1all"));
    se_stb = table2array(dat(:,"se_P1all"));
else
    dat = 0;
    lagt_stb = 0;
    RRD_stb = 0;
    se_stb = 0;
end

filename_ALD=char(strcat(str_ALD(1)));
if exist(filename_ALD,'file') == 2
    dat = readtable(filename_ALD, opts);

    lagt_ALD = table2array(dat(:,"lagtime"));
    RRD_ALD = table2array(dat(:,"RRD_P1all"));
    se_ALD = table2array(dat(:,"se_P1all"));
else
    dat = 0;
    lagt_ALD = 0;
    RRD_ALD = 0;
    se_ALD = 0;
end

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
if exist(filename_stb,'file')==2
    dat = readtable(filename_stb, opts);

    lagt_stb = table2array(dat(:,"lagtime"));
    RRD1_stb = table2array(dat(:,"RRD_P1all"));
    se1_stb = table2array(dat(:,"se_P1all"));
    RRD2_stb = table2array(dat(:,"RRD_P2all"));
    se2_stb = table2array(dat(:,"se_P2all"));
else
    dat = 0;
    lagt_stb = 0;
    RRD1_stb = 0;
    se1_stb = 0;
    RRD2_stb = 0;
    se2_stb = 0;
end




% str = {'Rresults/1hr_simple_RRD.txt'};
filename_ALD=char(strcat(str_ALD(1)));
if exist(filename_ALD,'file') == 2
    dat = readtable(filename_ALD, opts);

    
    lagt_ALD = table2array(dat(:,"lagtime"));
    RRD1_ALD = table2array(dat(:,"RRD_P1all"));
    se1_ALD = table2array(dat(:,"se_P1all"));
    RRD2_ALD = table2array(dat(:,"RRD_P2all"));
    se2_ALD = table2array(dat(:,"se_P2all"));
else
    dat = 0;

    lagt_ALD = 0;
    RRD1_ALD = 0;
    se1_ALD = 0;
    RRD2_ALD = 0;
    se2_ALD = 0;
end


dat = readtable(filename_ALD, opts);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltRRD_ALD_carbon' };
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
axb = 0.9;
axt = 0.9;
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
errorbar(lagt_stb,RRD_stb,se_stb,'-s','MarkerSize',10,...
    "Color",[150,150,150]./255,'LineWidth',6,"MarkerFaceColor",[150,150,150]./255)
errorbar(lagt_ALD,RRD_ALD,se_ALD,'-s','MarkerSize',10,...
    "Color",[82,82,82]./255,'LineWidth',6,"MarkerFaceColor",[82,82,82]./255)
set(gca,'XLim',[0,max(lagt_stb)],'Ylim',[0, maxy],TL{:},FS{[1,4]});
set(gca,TL{:},FS{[1,4]});
xlabel('Lag time [d]',TX{:},FS{[1,4]},UN{[1,3]});
ylabel('Flux-RRD [mg/(L$\cdot$ day)]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
[lgd, hobj, ~, ~] = legend('Stable: 2012-2021', 'Active ALD: 2007-2011',TX{:},FS{[1,4]},UN{[1,3]},'Location','northeast');
adjustLegendSize(lgd,hobj,1.05,1.00,10,1);

ax = gca;  % or use specific axes handle
% ax.YAxis.Exponent = -7;  % forces ×10⁻³ formatting

%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end


elseif NOinput == 2
    errorbar(lagt_stb,RRD1_stb,se1_stb,'-s','MarkerSize',10,...
        "Color",[166,189,219]./255,'LineWidth',3,"MarkerFaceColor",[0.65 0.85 0.90])
    hold on
    errorbar(lagt_ALD,RRD1_ALD,se1_ALD,'-s','MarkerSize',10,...
        "Color",[28,144,153]./255,'LineWidth',3,"MarkerFaceColor",[0.65 0.85 0.90])
    % set(gca,'XLim',[min(lagt_ALD),max(lagt_ALD)],'Ylim',[min(min([RRD1_stb-se1_stb; RRD1_ALD-se1_ALD])), max(max([RRD1_stb+se1_stb; RRD1_ALD+se1_ALD]))],TL{:},FS{[1,4]});
    set(gca,TL{:},FS{[1,4]});
    xlabel('Lag time [d]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
    ylabel('Rainfall -- Carbon Runoff Response Distribution [$\frac{\mathrm{mg}}{\mathrm{mm}^4}$]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
    title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
    legend('Stable: 2012-2021', 'Active ALD: 2007-2011',TX{:},FS{[1,4]},UN{[1,3]})
    line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);

    f2 = figure;
    set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
    set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
    set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
    set(f2,'Resize','off','Toolbar','none');
    ax = axes('Units','Inches','position',[axl axb axw axh]);

    hold on
    errorbar(lagt_stb,RRD2_stb,se2_stb,'-s','MarkerSize',10,...
        "Color",[253,187,132]./255,'LineWidth',3,"MarkerFaceColor",[252,141,98]./255)
    errorbar(lagt_ALD,RRD2_ALD,se2_ALD,'-s','MarkerSize',10,...
        "Color",[227,74,51]./255,'LineWidth',3,"MarkerFaceColor",[252,141,98]./255)
    % set(gca,'XLim',[min(lagt_stb),max(lagt_stb)],'Ylim',[min(min([RRD2_stb-se2_stb; RRD2_ALD-se2_ALD])), max(max([RRD2_ALD+se2_ALD; RRD2_ALD+se2_ALD]))],TL{:},FS{[1,4]});
    set(gca,TL{:},FS{[1,4]});
    xlabel('Lag time [d]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
    ylabel('Thawing -- Carbon Runoff Response Distribution [$\frac{\mathrm{mg}}{\mathrm{mm}^4}$]', TX{:}, FS{[1,4]}, UN{[1,3]}, 'Position', [-axl/2, axh/2]);
    title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
    line(ax.XLim, [0, 0], 'Color', 'black', 'LineStyle', '--', 'LineWidth', 1.5);
    legend('Stable: 2012-2021', 'Active ALD: 2007-2011',TX{:},FS{[1,4]},UN{[1,3]})
    %Save figure
     if printfig
         cd(workdirfig);
         str2       = {'ltRRD_Thaw_ALD_carbon' };
         figname   = char(strcat(str2(1)));
         print(f2,format,resl,rend,figname,'-loose');
         str2       = {'ltRRD_Rainfall_ALD_carbon' };
         figname   = char(strcat(str2(1)));
         print(f1,format,resl,rend,figname,'-loose');
     end
end