%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxRRD,maxRRDlgt,RRD,se,lagt] =  figtRRD_plot_knots(name,filename,workdir,workdirfig,printfig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%ignore extreme knots
ignex = 1;

% Import the data
cd(workdir)
% str = {'1hr_simple_RRD.txt'};
% filename=char(strcat(str(1)));
dat = readtable(filename);
% Extract the column names
columnNames = dat.Properties.VariableNames;

NOtests = numel(columnNames)-1;
NOtests2 = NOtests/2; 
indxRRD = 2:NOtests2+1;
indxse  = (NOtests2+2):NOtests+1;
columnNames_RRD = columnNames(indxRRD);

NOtestsp = NOtests2-ignex;

pattern = 'knot_RRD_p_(\d+)'; % pattern to match the number
colNums = cellfun(@(x) regexp(x, pattern, 'tokens'), columnNames_RRD); % extract the number using regexp
colNums = cellfun(@(x) str2double(x{1}), colNums); % convert the string to double

pattern = 'knot_RRD_p_(\d+[\_]\d+)'; % pattern to match decimal numbers with underscore or dot separator
colNums1 = cellfun(@(x) regexp(x, pattern, 'tokens'), columnNames_RRD, 'UniformOutput', false);  % extract the number using regexp
for j = 1:NOtestsp
    if numel(colNums1{1,j})>0
       colNums(j) = cellfun(@(x) str2double(strrep(x{1}, '_', '.')), colNums1{1,j}); % convert the string to double, replace underscore with dot
    end
end

lagt = table2array(dat(:,"lagtime"));
RRD = table2array(dat(:,indxRRD));
se = table2array(dat(:,indxse));

maxRRD = max(RRD);
minRRD = min(RRD);
for l = 1:NOtests2
index_lagt = RRD(:,l) ==maxRRD(l);
maxRRDlgt(l) = lagt(index_lagt);
maxRRDse(l) = se(index_lagt,l);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltRRD' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';

if NOtestsp == 4
    Colors = [
        168,221,181;
        123,204,196;
        67,162,202;
        8,104,172]./255;
elseif NOtestsp == 5
    Colors = [204,235,197;
        168,221,181;
        123,204,196;
        67,162,202;
        8,104,172]./255;
   
elseif NOtestsp == 6
    Colors = [240,249,232;
        204,235,197;
        168,221,181;
        123,204,196;
        67,162,202;
        8,104,172]./255;
elseif NOtestsp == 7
    Colors = [240,249,232;
        204,235,197;
        168,221,181;
        123,204,196;
        78,179,211;
        43,140,190;
        8,88,158]./255;
elseif NOtestsp == 8
    Colors = [247,252,240;
        224,243,219;
        204,235,197;
        168,221,181;
        123,204,196;
        78,179,211;
        43,140,190;
        8,88,158]./255;
end


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
LC = {'Color',Colors};


%Plotting profiles
axh = 5;
axw = 1.5*axh;
ahs = 0.15;
avs = 0.15;
axb = 0.7;
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
for l = 1:NOtestsp
    
e = errorbar(lagt(1:5:end)',RRD(1:5:end,l),se(1:5:end,l),'-','LineWidth',3,...
    'Color',Colors(l,:));
hold on
e.CapSize = 0;
end
set(gca,'XLim',[min(lagt),max(lagt)],'Ylim',[min(min([RRD-se])), max(max([RRD+se]))],TL{:},FS{[1,4]});
xlabel('Hour lag',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Runoff Response [1/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-2.*axl/3,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
for l = 1:NOtestsp
legendText{l} = strcat(num2str(round(100*colNums(l))/100), ' mm/hr Rainfall');
end
legend(legendText,TX{:},FS{[1,5]},'Location','eastoutside');

%Save figure
if printfig
    cd(workdirfig);
    % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['ltRRD_knots_' filename];
    
    figname   = str2; %char(strcat(str2(1),str2(2)));
    print(f1,format,resl,rend,figname,'-loose');
end


%set figure page
f2 = figure;
set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f2,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);
hold on
plot(colNums(1:NOtestsp),maxRRD(1:NOtestsp),'.','MarkerSize',50,'Color','k')
errorbar(colNums(1:NOtestsp),maxRRD(1:NOtestsp),maxRRDse(1:NOtestsp),'ok','LineStyle', 'none','MarkerSize',10,...
         "MarkerEdgeColor","black")
for jj = 1:NOtestsp
    plot(colNums(jj),maxRRD(jj),'.','MarkerSize',45,'Color',Colors(jj,:))
    hold on
end
set(gca,'XLim',[0,max(colNums(NOtestsp))],'Ylim',[0, max(maxRRD+maxRRDse)],TL{:},FS{[1,5]});
% legend(legendText,TX{:},FS{[1,5]},'Location','southeast');
%set axis
xlabel('Rainfall [mm/hr]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Peak Runoff Response Rate [1/hr]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[-2.*axl/3,axh/2]);
  

%Save figure
if printfig
  cd(workdirfig);
  % set printing options
    % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['maxRRD_knot_', filename];
    figname   = str2; %char(strcat(str2(1)),strcat(str2(2)));

  format    = '-dpng';
  resl      = '-r200';
  rend      = '-opengl';
%   figname   = char(strcat(str(1)));
  print(f2,format,resl,rend,figname,'-loose');
end
