function [maxNRF,maxNRFlgt,NRF,se,lagt] =  figtNRF_plot_knots(name,filename, workdir,workdirfig,printfig)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%ignore extreme knots
ignex = 1;

% Import the data
cd(workdir)
% str = {'1hr_simple_NRF.txt'};
% filename=char(strcat(str(1)));
dat = readtable(filename);
% Extract the column names
columnNames = dat.Properties.VariableNames;

NOtests = numel(columnNames)-1;
NOtests2 = NOtests/2; 
indxNRF = 2:NOtests2+1;
indxse  = (NOtests2+2):NOtests+1;
columnNames_NRF = columnNames(indxNRF);

NOtestsp = NOtests2-ignex;

pattern = 'knot_NRF_p_(\d+)'; % pattern to match the number
colNums = cellfun(@(x) regexp(x, pattern, 'tokens'), columnNames_NRF); % extract the number using regexp
colNums = cellfun(@(x) str2double(x{1}), colNums); % convert the string to double

pattern = 'knot_NRF_p_(\d+[\_]\d+)'; % pattern to match decimal numbers with underscore or dot separator
colNums1 = cellfun(@(x) regexp(x, pattern, 'tokens'), columnNames_NRF, 'UniformOutput', false);  % extract the number using regexp
for j = 1:NOtestsp
    if numel(colNums1{1,j})>0
       colNums(j) = cellfun(@(x) str2double(strrep(x{1}, '_', '.')), colNums1{1,j}); % convert the string to double, replace underscore with dot
    end
end


lagt = table2array(dat(:,"lagtime"));
NRF = table2array(dat(:,indxNRF));
se = table2array(dat(:,indxse));

maxNRF = max(NRF);
minNRF = min(NRF);
for l = 1:NOtests2
index_lagt = NRF(:,l) ==maxNRF(l);
maxNRFlgt(l) = lagt(index_lagt);
maxNRFse(l) = se(index_lagt,l);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
str       = {'ltNRF' };
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
ahs = 0.8;
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
ax = axes('Units','Inches','position',[axl+ahs axb axw axh]);

%Plot figure
hold on
for l = 1:NOtestsp
e=errorbar(lagt(1:5:end)',NRF(1:5:end,l),se(1:5:end,l),'-','LineWidth',4,...
    'Color',Colors(l,:));
hold on
e.CapSize = 0;
end

set(gca,'XLim',[min(lagt),max(lagt)],'Ylim',[min(min([NRF-se])), max(max([NRF+se]))],TL{:},FS{[1,4]});
xlabel('Hour lag',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Hr Rainfall Response Rate  [mm/hr]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2-ahs/2,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
for l = 1:NOtestsp
legendText{l} = strcat(num2str(round(100*colNums(l))/100), ' mm/hr');
end
legend(legendText,TX{:},FS{[1,3]},'Location','northeast')

%Save figure
if printfig
    cd(workdirfig);
     % Remove prefixes and suffixes
    filename = erase(filename, '1hr_simple_');
    filename = erase(filename, '.txt');
    str2       = ['ltNRF_knots_' filename];
    
    figname   = str2; %char(strcat(str2(1),str2(2)));
    print(f1,format,resl,rend,figname,'-loose');
end


%set figure page
f2 = figure;
set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f2,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl + ahs axb axw axh]);
hold on
plot(colNums(1:NOtestsp),maxNRF(1:NOtestsp),'.','MarkerSize',50,'Color','k')
errorbar(colNums(1:NOtestsp),maxNRF(1:NOtestsp),maxNRFse(1:NOtestsp),'ok','LineStyle', 'none','MarkerSize',10,...
         "MarkerEdgeColor","black")
for jj = 1:NOtestsp
    plot(colNums(jj),maxNRF(jj),'.','MarkerSize',45,'Color',Colors(jj,:))
    hold on
end
set(gca,'XLim',[0,max(colNums(NOtestsp))],'Ylim',[0, max(maxNRF+maxNRFse)],TL{:},FS{[1,5]});
% legend(legendText,TX{:},FS{[1,5]},'Location','southeast');
%set axis
xlabel('Rainfall [mm/hr]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Hr Rainfall Peak Response Rate [mm/hr]',TX{:},FS{[1,5]},UN{[1,3]},'Position',[-axl/2-ahs/2,axh/2]);
  

%Save figure
if printfig
  cd(workdirfig);
  % set printing options
  format    = '-dpng';
  resl      = '-r200';
  rend      = '-opengl';
    str2       = ['maxNRF_knots_' filename];
    
    figname   = str2; %char(strcat(str2(1),str2(2)));
    print(f2,format,resl,rend,figname,'-loose');
end