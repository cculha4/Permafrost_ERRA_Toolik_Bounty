%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtQP_plot_CB_wiMatlab_years(t,Q,P,maxP)


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

year = floor(t(1));
July = year+.4973;
June = year + .4153;
August = year + .582;

mint = year + .3;
Sept1 = year + .67;
Oct1 = year + .75;

% 

% colororder({'b','k'})

hold on

% yyaxis right   
plot(t,P,'-','Color',[54,144,192]./255)
hold on
area(t, P, 'FaceColor', [54,144,192]./255, 'FaceAlpha', 0.7)
plot(t,P,'-','Color',[54,144,192]./255)

% yyaxis left
plot(t,Q,'-k',LW{[1,end]})
set(gca,'XLim',[June,Sept1],'Ylim',[0, maxP],TL{:},FS{[1,4]});
xticklabels([])
text(June, min(P)-maxP./15*2, 'J', 'HorizontalAlignment', 'center',TX{:},FS{[1,4]})
text(July, min(P)-maxP./15*2, 'J', 'HorizontalAlignment', 'center',TX{:},FS{[1,4]})
text(August, min(P)-maxP./15*2, 'A', 'HorizontalAlignment', 'center',TX{:},FS{[1,4]})
text(Sept1, min(P)-maxP./15*2, 'S', 'HorizontalAlignment', 'center',TX{:},FS{[1,4]})

