%%%%% Modeling Thaw Depth using DDT%%%%%%%%%%%%%%
clear all
close all

writetables = 0;
workdirERRA = '/Users/cansu/Documents/GitHub/Permafrost_ERRA/datERRA/UK_thawingdepth_daily_2';
workdirfig = '/Users/cansu/Documents/GitHub/Permafrost_ERRA/datERRA/UK_thawingdepth_daily_2/figures';
txtname = 'UK_thaw_synthesized_data.txt';
cd(workdirERRA)
AirTemp = load('airtemp.mat');
precipitation = load('precipitation.mat');
discharge = load('dischargedaily.mat');
DepthAL = load('/Users/cansu/Documents/GitHub/Permafrost_ERRA/datERRA/UK_years/DepthAL_temperature.mat');
name      = {'Upper Kuparuk'};
printfig  = 1; 



temp = AirTemp.airtemp_da;
months = AirTemp.months_da;
time = AirTemp.time_da;
cs_T = cumsum(temp);
DDT = zeros(size(temp));

for ll = 2:numel(temp)
    if months(ll) == 4
        DDT(ll) = 0;
        continue
    end

    if months(ll) > 9
        DDT(ll) = NaN;
        continue
    end
    
    if temp(ll) > 0
       DDT(ll) = DDT(ll-1) + temp(ll);
    else
        DDT(ll) = DDT(ll-1) + 0;
    end
end




depthal_trim_nan = ~isnan(DepthAL.depthAL_trim);
depthal_trim = DepthAL.depthAL_trim(depthal_trim_nan);
depthal_t = DepthAL.t_(depthal_trim_nan);

% Define the periods for September to March for each year in your data
startYear = floor(min(DepthAL.t_));
endYear = ceil(max(time));



%%%Figure
% set printing options


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
str       = {'Thaw_Thickness_raw' };
set(f1,'Units','Inches','Position',[0.7 12 fw fh]);
set(f1,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f1,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f1,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);



plot(time, 2.5*sqrt(DDT),'.k','MarkerSize',35)
hold on

 

for year = startYear:endYear
    % Convert September to March into decimal format for the given year
    sep = datenum(year, 9, 10);
    mar = datenum(year, 3, 31);
    
    % Convert dates from datenum to decimal year
    sep_dec = decyear(sep); %year + (sep - datenum(year, 1, 1)) / 365.25;
    mar_dec = decyear(mar); %year + 1 + (mar - datenum(year + 1, 1, 1)) / 365.25;
    
    for ll =1:numel(depthal_trim)
        if depthal_t(ll) < sep_dec && depthal_t(ll)>mar_dec
         plot(depthal_t(ll),depthal_trim(ll),'ob','MarkerSize',10,'LineWidth',5)
        end
    end

end


set(gca,'XLim',[min(time),max(time)],TL{:},FS{[1,4]});
xlabel('Time',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Thaw Depth [cm]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
legend('Model $Z = 2.5\sqrt{\mathrm{DDT_{hourly}}}$', 'Data',TX{:},FS{[1,4]},UN{[1,3]})

%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f1,format,resl,rend,figname,'-loose');
end





Z_25 = [2.5*sqrt(DDT) 0];

dZ = Z_25(2:end)-Z_25(1:end-1);
dZ(dZ<0) = NaN;

Z_5 = [5*sqrt(DDT) 0];

dZ_5 = Z_5(2:end)-Z_5(1:end-1);



%set figure page
f2 = figure;
str       = {'Thaw_depth_models' };
set(f2,'Units','Inches','Position',[0.7 12 fw fh]);
set(f2,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f2,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f2,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

hold on
plot(time, Z_25(1:end-1),'.','MarkerSize',35,'Color',[0 0 0])
plot(time, Z_5(1:end-1),'.','MarkerSize',35,'Color',[.7 .7 .7])

set(gca,'XLim',[min(time),max(time)],TL{:},FS{[1,4]});
xlabel('Time',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Thaw Depth [cm]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
legend('$Z = 2.5\sqrt{\mathrm{DDT_{hourly}}}$', '$Z = 5\sqrt{\mathrm{DDT_{hourly}}}$',TX{:},FS{[1,4]},UN{[1,3]})
%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f2,format,resl,rend,figname,'-loose');
end
%set figure page
f3 = figure;
str       = {'Thaw_water' };
set(f3,'Units','Inches','Position',[0.7 12 fw fh]);
set(f3,'PaperPosition',[0 0 fw*2.2 fh*2.2],'PaperSize',[fw fh]);
set(f3,'Color','w','InvertHardcopy','off', 'MenuBar','none');
set(f3,'Resize','off','Toolbar','none');
ax = axes('Units','Inches','position',[axl axb axw axh]);

hold on
plot(time, .30*dZ,'.','MarkerSize',35,'Color',[0 0 0])
plot(time, .05*dZ,'.','MarkerSize',35,'Color',[.7 .7 .7])

set(gca,'XLim',[min(time),max(time)],TL{:},FS{[1,4]});
xlabel('Time',TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,-axb/2]);
ylabel('Thawed Water [cm$^3$]',TX{:},FS{[1,4]},UN{[1,3]},'Position',[-axl/2,axh/2]);
title(name,TX{:},FS{[1,4]},UN{[1,3]},'Position',[axw/2+ahs/2,axh])
legend('$0.30 \times dZ_{2.5}$', '$0.05 \times dZ_{2.5}$',TX{:},FS{[1,4]},UN{[1,3]})


%Save figure
if printfig
  cd(workdirfig);
  figname   = char(strcat(str(1)));
  print(f3,format,resl,rend,figname,'-loose');
end


%Save files to txt
%First make a table
shortt = time';
years = floor(time)';
months = months';
airtemp = temp';
P = precipitation.precip_da';
Q = discharge.Q_da'; %<-- convert to m^3/s mm/hr
ThawDepth = Z_25(1:end-1)';
dZ = dZ';

Mtxt = table(shortt,years,months,...
    airtemp,P,Q,ThawDepth,dZ);
if writetables ==1
    cd(workdirERRA)
    writetable(Mtxt,txtname,'WriteRowNames',true,'Delimiter',',');
 end


