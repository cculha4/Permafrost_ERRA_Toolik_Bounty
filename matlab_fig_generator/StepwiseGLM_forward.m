%%%%%%%%% Stepwise Generalized Linear Modeling %%%%%%%%
%%%%%Forward Selection%%%%%%%%%
%Another link to do Stepwisefit: https://ch.mathworks.com/help/stats/stepwisefit.html
% Step 1: Load and prepare the data
close all
clear all
%Where is your data?
workdir = '~/Documents/git_Research/Permafrost_ERRA/Permafrost_ERRA/datERRA/UK_years';
cd(workdir)
load('Considered_VarParameters.mat');
turnzscore = true;

% Step 1.1: Identify the type of model to plot
f = figure;
GLMCrits = ["AIC","BIC"];

VarNames = {'meanTJuly', 'TSummer', 'CountTgt0', 'CountTall', 'Q_max_april_june', 'SD_max', ...
    'totalPSummer', 'totalPSummer_Yrbfr', 'totaldaysPgt0', 'totaldaysPgt0_Yrbfr',...
    'totalRFSummer', 'totalRFSummer_Yrbf', 'totaldaysRFgt0', 'totaldaysRFgt0_Yrbf', 'RF_intensity', 'RF_intensity_Yrbf'};
outputty = maxRRD;


NOvar = numel(VarNames);
% Step 1.2: Evaluate in zscore
if turnzscore
    outputty = zscore(outputty);
    for ll = 1:NOvar
        VarParameters(ll,:) = zscorenan(VarParameters(ll,:));
        param_name = VarNames{ll};
        param_value = eval(param_name);
        zscore_value = zscorenan(param_value);
        zscore_parameters{ll} = zscore_value;
        assignin('base',param_name,zscore_value);
    end
end

% Step 1.3: Define Figure characteristics 
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


% Calculate the number of rows and columns for the subplot
num_cols = numel(GLMCrits);
num_rows = 1;



% Adjust the figure size if desired
fig_width = 800; % Adjust as desired
fig_height = 400; % Adjust as desired
set(gcf, 'Position', [100, 100, fig_width, fig_height]);




mycolormap = [166,97,26;
223,194,125;
128,205,193;
1,133,113;
255 255 255]./255;


% Step 2: Set up the initial model
mm_value = 0;

for gll = 1:numel(GLMCrits)
% Step 3: Initialize forward stepwise procedure
bestModel = [];
rotation_variables = zeros(numel(VarNames));
bestRsqrd = 0;


% Step 4-8: Forward stepwise iteration
for ll = 1:NOvar
   
    bestFitMeasure = Inf; % Initialize best fit measure
    bestVariable = '';
    ldx = [];
    currentModel = {}; % Empty model

    % Step 4: Iterate through the variables
    for idx = 1:NOvar
        % Step 5: Fit GLM with added variable
        ldx = [ldx, idx];
        newModel = [currentModel, VarNames{idx}];
        
        dd = [VarParameters(ldx,:)', outputty'];
        vnames =  {VarNames{ldx},'output'};
        data = array2table(dd, 'VariableNames',vnames);
        glm = fitglm(data, 'Distribution', 'normal', 'PredictorVars', newModel);
        
        % Step 6: Assess model fit
        fitMeasure(ll) = glm.ModelCriterion.(GLMCrits{gll}); % Use BIC as the fit measure
         
        % Step 7: Determine best variable
       if fitMeasure(ll) < bestFitMeasure
            bestFitMeasure = fitMeasure(ll);
            variable = ldx+ll-1;       %need to correct for the rotation
            variable(variable>NOvar) = variable(variable>NOvar)-NOvar; 
            rotation_variables(ll,variable) = glm.Coefficients.Estimate(2:end);
            currentModel = newModel;
            rotation_Rsqrd(ll) = glm.Rsquared.Adjusted;
            rotation_prediction(ll,:) = glm.predict;
       else
           ldx = ldx(1:end-1);
       end
    end
    if rotation_Rsqrd(ll)>bestRsqrd
        %Best model
        bestmodel = newModel;
        bestglm = glm;
        bestRsqrd = rotation_Rsqrd(ll);
    end
    % Rotate variables once over
    VarNames = [VarNames(2:end), VarNames(1)];
    VarParameters = [VarParameters(2:end,:);VarParameters(1,:)];
end
    
%%%%Identify the best model
%Rotation with best Rsqrd
best_rotation = find(rotation_Rsqrd == nanmax(rotation_Rsqrd));
secondbest_rotation = rotation_Rsqrd(rotation_Rsqrd~=best_rotation);
secondbest_rotation = find(rotation_Rsqrd == max(secondbest_rotation));
%Linear Regression Fits
best_model = rotation_variables(best_rotation,:);
%Name of the variables that fit the best
best_varnames = VarNames{best_model~=0};

%Plotting The Results of the Model

subplot(1,num_cols,gll)



% Calculate the maximum absolute value of the data
max_value(gll) = max(abs(rotation_variables(:)));


plot_results = rotation_variables;
plot_results(plot_results==0) = Inf;

% Plotting the matrix using imagesc
imagesc(plot_results);

% Set the colormap and center it around 0
colormap(mycolormap);

if max_value(gll)>mm_value
    mm_value = max_value(gll);
end
caxis([-mm_value, 1.5*mm_value]);
% if gll == numel(GLMCrits)
colorbar
% end

% Label the axes
x_ticks = 1:length(VarNames);

% Set the x-axis tick labels as variable names
xticks(x_ticks);
xticklabels(VarNames)

% Rotate the x-axis tick labels by a slight angle
xtickangle(45);

y_ticks = 1:length(rotation_Rsqrd);
yticks(y_ticks);
yticklabels(round(100.*rotation_Rsqrd)./100)


ylabel('R^2',UN{[1,3]});
title(GLMCrits{gll},UN{[1,3]})
fontname(f,"Times New Roman")
set(gca,FS{[1,4]});

end