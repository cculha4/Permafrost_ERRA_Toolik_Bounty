function antecedent_check_runoff(workdir,workdirfig,printfig,laghr,colNums,lagQrange)




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
UKsynthesizeddata = readtable("/Users/cansu/Documents/GitHub/Permafrost_ERRA/datERRA/UK/UK_synthesized_data.txt", opts);

Q = table2array(UKsynthesizeddata(:,"Q"));
P = table2array(UKsynthesizeddata(:,"P"));
Temp = table2array(UKsynthesizeddata(:,"airtemp"));
months = table2array(UKsynthesizeddata(:,"months"));
shortt = table2array(UKsynthesizeddata(:,"shortt"));
%% Clear temporary variables
clear opts

%% isolate rain not precipitation 

snowfree = months>4&months<11&Temp>2;

P_snowfree = P(snowfree);
Q_snowfree = Q(snowfree);

Qranges = lagQrange;
xvalues = colNums;%mean([colNums(1:end-1);colNums(2:end)]);
NOtestsp = numel(xvalues);

    %Check the # hour lag difference 
    %hypothesis there is a correlation with 6 hour lag in runoff and
    %rainfall intensity

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



sizes = numel(P);

f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

for l = 1:numel(colNums) 
    subplot(numel(colNums),1,numel(colNums) - l+1)
    indx = Q > Qranges(l) & Q<=Qranges(l+1) & snowfree;
    id = find(indx);
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
        xlabel('Rainfall [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]});
    end

end



%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('Pdisp_4_each',laghr,'hrQ_lag2_rainfall'));
  print(f1,format,resl,rend,figname,'-loose');
end

f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

% 
% errorbar(log10(xvalues),P_med,P_std,'.k','MarkerSize',20*2,...
%          "MarkerEdgeColor","black");
hold on
plot(log10(xvalues),P_med,'.','MarkerSize',50*2,'Color','k')
errorbar(log10(xvalues),P_med,P_std,'ok','LineStyle', 'none','MarkerSize',10*2,...
         "MarkerEdgeColor","black")
for jj = 1:NOtestsp
    plot(log10(xvalues(jj)),P_med(jj),'.','MarkerSize',45*2,'Color',Colors(jj,:))
    hold on
end






title({'Average Rainfall Intensity for',' each 6-hour lag in Antecedent Runoff'},TX{:},FS{[1,4]});

%Set axis
xlabel('Log Antecedent Q [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Av. Rainfall [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
set(gca,'YLim',[0,0.6],TL{:},FS{[1,4]});
  
%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat('meanP_4_each',laghr,'hrQ_lag_rainfall'));
  print(f1,format,resl,rend,figname,'-loose');
end
