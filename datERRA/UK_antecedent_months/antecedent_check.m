function antecedent_check(workdir,workdirfig,printfig,laghr,colNums,lagQrange)
%% Set up the Import Options and import the data

NOtestsp = numel(colNums);
Qranges = lagQrange;

if NOtestsp == 3
    Colors = [
251,180,185
197,27,138
122,1,119]./255;
elseif NOtestsp == 4
    Colors = [
251,180,185
247,104,161
197,27,138
122,1,119]./255;
elseif NOtestsp == 5
    Colors = [254,235,226
251,180,185
247,104,161
197,27,138
122,1,119]./255;
   
elseif NOtestsp == 6
    Colors = [254,235,226
252,197,192
250,159,181
247,104,161
197,27,138
122,1,119]./255;
elseif NOtestsp == 7
    Colors = [254,235,226
252,197,192
250,159,181
247,104,161
221,52,151
174,1,126
122,1,119]./255;
elseif NOtestsp == 8
    Colors = [255,247,243
253,224,221
252,197,192
250,159,181
247,104,161
221,52,151
174,1,126
122,1,119]./255;
end

  %% Set up the Import Options and import the data
    opts = delimitedTextImportOptions("NumVariables", 7);

    % Specify range and delimiter
    opts.DataLines = [2, Inf];
    opts.Delimiter = "\t";

    % Specify column names and types
    opts.VariableNames = ["timestep", "time", "weight", "P", "Q", "Qfitted", "Qresidual"];
    opts.VariableTypes = ["double", "double", "double","double", "double", "double", "double"];

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

    P = table2array(dat(:,"P"));
    Q = table2array(dat(:,"Q"));
    t = table2array(dat(:,"time"));


    % 
    % 
    % Q_lag = Q(1:end-laghr+1);
    % P_lag = P(laghr:end);

    %Check the # hour lag difference 
    %hypothesis there is a correlation with 6 hour lag in runoff and
    %precipitation intensity

% set printing options
str       = {'PQ_lag_scatter' };
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
FS = {'FontSize',10*2,15*2,18*2,21*2,24*2};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};


%Plotting profiles
axh = 5;
axw = 1.5*axh;
ahs = 0.8;
avs = 0.15;
axb = 0.7;
axt = 0.5;
axl = 1.0;
axr = 0.5;
cbh = axh; cbw = 0.2; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;





f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

sizes = numel(P);
for l = 1:numel(colNums) 
    subplot(numel(colNums),1,numel(colNums) - l+1)
    id = find(Q > Qranges(l) & Q<=Qranges(l+1));
    id(id+laghr>sizes) = []; %drop the data that is beyond the datasize when considering lag hour
    dataP = P(id+laghr);
    [pdf,x_values] = ksdensity(dataP);
    histogram(dataP,20,'Normalization','probability');
    hold on
    plot(x_values,pdf)
    % hist(P(id+laghr),100)
    P_med(l) = nanmean(dataP);
    P_std(l) = nanstd(dataP);
    xlim([0,3])
    ylim([0,1])
    toprightText = strcat(num2str(Qranges(l)), '-', num2str(Qranges(l+1)),' Antec. Q');
    text(1.75, 0.5, toprightText,TX{:},FS{[1,3]});
    set(gca,TL{:},FS{[1,4]});
    if l>1
        set(gca,'xticklabel',[])
    end
    if l == 1
        xlabel('Precipitation [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]});
    end

end



%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('Pdisp_4_each',laghr,'hrQ_lag2'));
  print(f1,format,resl,rend,figname,'-loose');
end


f1 = figure;
set(f1,'Units','Inches','Position',[0.9 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

for l = 1:numel(colNums) 
    % subplot(numel(colNums)-1,1,numel(colNums) - l)
    id = find(Q > Qranges(l) & Q<=Qranges(l+1));
    id(id+laghr>sizes) = []; %drop the data that is beyond the datasize when considering lag hour
    dataP = P(id+laghr);
    h = cdfplot(dataP); %%%% LOG y-axis
    h.Color = Colors(l,:);
    h.LineWidth = 5;
    hold on
end
% Set the y-axis to logarithmic scale
set(gca, 'YScale', 'log');

for l = 1:NOtestsp
legendText{l} = strcat(num2str(round(100*Qranges(l))/100),'-', num2str(round(100*Qranges(l+1))/100), ' mm/hr');
end
legend(legendText,TX{:},FS{[1,4]},'Location','northeast');
set(gca,'XLim',[0,4],'Ylim',[0,1],TL{:},FS{[1,5]});
xlabel('Rainfall [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]});
ylabel('Log Cumulative Distribution Function',TX{:},FS{[1,4]},UN{[1,3]});
title([])

%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('CDF_Pdisp_4_each',laghr,'hrQ_lag2'));
  print(f1,format,resl,rend,figname,'-loose');
end










f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

errorbar(colNums,P_med,P_std,'ok','MarkerSize',10*2,...
         "MarkerEdgeColor","black");


title({'Average Precipitation Intensity for',' each 6-hour lag in Antecedent Runoff'},TX{:},FS{[1,4]});

%Set axis
xlabel('Antecedent Q [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Av. Precipitation [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
set(gca,TL{:},FS{[1,4]});
  
%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('meanP_4_each',laghr,'hrQ_lag'));
  print(f1,format,resl,rend,figname,'-loose');
end


f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);
PcolNums = nan(size(P));
for l = 1:numel(colNums)
    hold on
    id = find(Q > Qranges(l) & Q<=Qranges(l+1));
    id(id+laghr>sizes) = []; %drop the data that is beyond the datasize when considering lag hour
    dataP = P(id+laghr);
    PcolNums(id+laghr) = colNums(l);
end

boxplot(P,PcolNums);

title({'Average Precipitation Intensity for',' each 6-hour lag in Antecedent Streamflow'},TX{:},FS{[1,4]});

%Set axis
xlabel('Antecedent Q [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Av. Precipitation [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
set(gca,TL{:},FS{[1,4]});
  
%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('meanP_boxPlot',laghr,'hrQ_lag'));
  print(f1,format,resl,rend,figname,'-loose');
end

