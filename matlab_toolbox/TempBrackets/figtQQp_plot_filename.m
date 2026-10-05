%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [f1] = figtQQp_plot_filename(filename,brackets_name,bracket,brackety,workdir,workdirfig,printfig,NOinput)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if NOinput == 1
    %% Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 6);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = "\t";

    % Specify column names and types
    opts.VariableNames = ["timestep", "time", "P", "Q", "Qfitted", "Qresidual"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";

    % Specify variable properties
    opts = setvaropts(opts, ["Qfitted", "Qresidual"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["Qfitted", "Qresidual"], "ThousandsSeparator", ",");

    % Import the data
    cd(workdir)
%     str = {'1hr_simple_Qcomp.txt'};
%     filename=char(strcat(str(1)));
    dat = readtable(filename, opts);

    P = table2array(dat(:,"P"));
    Q = table2array(dat(:,"Q"));
    Qp = table2array(dat(:,"Qfitted"));
    Qr = table2array(dat(:,"Qresidual"));
    t = table2array(dat(:,"time"));

elseif NOinput == 2
     opts = delimitedTextImportOptions("NumVariables", 7);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = "\t";

    % Specify column names and types
    opts.VariableNames = ["timestep", "time", "PV1", "PV2", "Q", "Qfitted", "Qresidual"];
    opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double"];

    % Specify file level properties
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";


    % Specify variable properties
    opts = setvaropts(opts, ["Qfitted", "Qresidual"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["Qfitted", "Qresidual"], "ThousandsSeparator", ",");

    % Import the data
    cd(workdir)
    str = {'1hr_simple_Qcomp.txt'};
    filename=char(strcat(str(1)));
    dat = readtable(filename, opts);

    P = table2array(dat(:,"PV1"));
    Temp = table2array(dat(:,"PV2"));
    Q = table2array(dat(:,"Q"));
    Qp = table2array(dat(:,"Qfitted"));
    Qr = table2array(dat(:,"Qresidual"));
    t = table2array(dat(:,"time"));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'tQQp' };
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
ahs = 0.15;
avs = 0.15;
axb = 0.7;
axt = 0.5;
axl = 0.8;
axr = 0.5;
cbh = axh; cbw = 0.2; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;



%Set figure page
f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

% Plot figures
if brackety == 1
plot(t(bracket),Q(bracket),'.k')
hold on
plot(t(bracket),Qp(bracket),'.b')
plot(t(bracket),Qr(bracket),'.r')

set(gca,'XLim',[min(t(bracket)),max(t(bracket))],'Ylim',[0, max(Q(bracket))],TL{:},FS{[1,4]});
else
    plot(t,Q,'.k')
hold on
plot(t,Qp,'.b')
plot(t,Qr,'.r')

set(gca,'XLim',[min(t),max(t)],'Ylim',[0, max(Q)],TL{:},FS{[1,4]});
end

%Set axis
xlabel('t',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Q, Q predicted, Q residual',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
legend('data','predicted', 'residual',FS{[1,3]},TX{[1,2]});
 
%%%Save figure
if printfig
  cd(workdirfig);
  str   = [brackets_name,"_QQP"];
  figname=char(strcat(str(1),str(2)));
  print(f1,format,resl,rend,figname,'-loose');
end

