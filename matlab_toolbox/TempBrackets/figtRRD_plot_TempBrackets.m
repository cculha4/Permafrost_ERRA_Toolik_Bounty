%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Creating figures that match what is in the introduction%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [maxRRD,maxRRDlgt,RRD,se,lagt] = figtRRD_plot_TempBrackets(filename,workdir,color)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["lagtime", "RRD_P1all",  "se_P1all"];
opts.VariableTypes = ["double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
cd(workdir)
dat = readtable(filename, opts);

lagt = table2array(dat(:,"lagtime"));
RRD = table2array(dat(:,"RRD_P1all"));
se = table2array(dat(:,"se_P1all"));

maxRRD = max(RRD);
minRRD = min(RRD);
index_lagt = find(RRD ==maxRRD);
maxRRDlgt = lagt(index_lagt);


%Plot figure
hold on
e = errorbar(lagt,RRD,se,'-','LineWidth',4,'Color',color);
e.CapSize = 0;


