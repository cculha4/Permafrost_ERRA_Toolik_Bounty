%%%%%%
%Script for compiling the figure generator
%%%%%%

clear all
close all

%What is your project name?
ProjFolder = 'Introduction';

%What is the original data?
originaldata = {'vignettes_data.txt'};

%do you want the figure saved?
printfig  = true;

%Where do you want to save files?
workdirfigures = '~/Documents/git_Research/Permafrost_ERRA/Permafrost_ERRA/figures/';

%Where is your data?
workdir = '~/Documents/git_Research/Permafrost_ERRA/Permafrost_ERRA/datERRA';

%Set directories
workdirfig_ = {workdirfigures, ProjFolder};
workdirfig=char(strcat(workdirfig_(1),workdirfig_(2)));
if ~exist(workdirfig, 'dir')
    cd(workdirfigures)
    mkdir(ProjFolder)
end
cd(workdir)


%Plot time with discharge and precipitation. This function will change
%depending on data format. Please change this function accordingly
origdat=char(strcat(originaldata(1)));
f1 = figtQP_plot(origdat,workdir,workdirfig,printfig)

%Plot P and Q as scatter. We use data from ERRA so this is standardized
f2 = figPQ_scatter(workdir,workdirfig,printfig)

%Plot ERRA time with real discharge, predicted discharge, and its residual
f3 = figtQQp_plot(workdir,workdirfig,printfig)

%Plot lagtime with RRD
f4 = figtRRD_plot(workdir,workdirfig,printfig)




