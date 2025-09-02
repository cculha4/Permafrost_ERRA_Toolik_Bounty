%%%%% Modeling Thaw Depth using DDT%%%%%%%%%%%%%%
clear all
close all
cd('/Users/cculha/Documents/git_research/Permafrost_ERRA/Permafrost_ERRA/datERRA/UK_years')
AirTemp = load('AirTemp.mat');
DepthAL = load('DepthAL_temperature.mat');

temp = AirTemp.temp_daily;
time = AirTemp.t_daily;

cs_T = cumsum(temp);
DDT = zeros(size(temp));

for ll = 2:numel(temp)
    if month(time(ll)) == 1
        DDT(ll) = 0;
        continue
    end
    if ll == 556
        disp('556')
    end
    if temp(ll) > 0
       DDT(ll) = DDT(ll-1) + temp(ll);
    else
        DDT(ll) = DDT(ll-1) + 0;
    end
end

plot(decyear(time), 2.5*sqrt(DDT),'.k','MarkerSize',25)
hold on
plot(DepthAL.t_,DepthAL.depthAL_trim,'or')

dif_DDT = DDT(2:end)-DDT(1:end-1);

