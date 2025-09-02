%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f1 = figtQT_plot(t,Q,T,workdirfig,printfig,names_,str)
%% names_ 'Q [mm/hr]', 'Temperature [$^{\circ}$C]'


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%FIGURES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set printing options
% str       = {'tQT' };
format    = '-dpng';
resl      = '-r200';
rend      = '-opengl';



% prepare formating options
HA = {'HorizontalAlignment','left','center','right'};
VA = {'VerticalAlignment','bottom','middle','top'};
UN = {'Units','Normalized','Inches'};
TX = {'Interpreter','Latex'};
TL = {'TickLabelInterpreter','Latex'};
LW = {'LineWidth',1,1.25,1.5,10};
FS = {'FontSize',10*3,15*3,18*3,21*3,30*3};
MS = {'MarkerSize',6,8,12};
LS = {'LineStyle','-','--','-.',':'};
% LC = {'Color',color};


%Plotting profiles
axh = 5;
axw = 2*axh;%4*
ahs = 0.15;
avs = 0.15;
axb = 2.3;
axt = 2.0;
axl = 2.;
axr = axl;
cbh = axh; cbw = 0; ht = 0.05;
fh = axb + 1*axh + 1*avs + 1*ht + axt ;
fw = axl  + axw + ahs + cbw + axr;




f1 = figure;
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw 2*fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax(1) = axes('Units','Inches','position',[axl axb+avs axw axh]);
% set(f1,'Units','Inches','Position',[0.7 12 fw fh*2]);
% ax(1) = axes('Units','Inches','position',[axl*2 axb+avs axw axh]);

colororder({'k','b'})
mint = find((t == {'01-Jul-2023'}));
maxt = find(t==max(t)); %t == {'05-Jul-2023'});
yyaxis left
plot(t,Q,'-k',LW{[1,end]})
xlabel('t',TX{:},FS{[1,5]},UN{[1,3]});
ylabel(names_{1},TX{:},FS{[1,5]},UN{[1,3]})%,'Position',[-axl/2,axh/2]);
set(gca, LW{[1,4]},'XLim',[t(mint),t(maxt)],'Ylim',[0, max(Q(mint:maxt))],TL{:},FS{[1,5]});

hold on

yyaxis right   
plot(t,T,'-b',LW{[1,end]})
xlabel('t',TX{:},FS{[1,5]},UN{[1,3]});
ylabel(names_{2},TX{:},FS{[1,5]},UN{[1,3]})%,'Position',[fw-3*axr/2,axh/2]);
set(gca, LW{[1,4]},'XLim',[t(mint),t(maxt)],'Ylim',[0, max(T(mint:maxt))],TL{:},FS{[1,5]});
% max(t)
xtickformat('dd') 

%Saving Figures
if printfig
  cd(workdirfig);
  figname   = char(strcat(str));
  print(f1,format,resl,rend,figname,'-loose');
end
