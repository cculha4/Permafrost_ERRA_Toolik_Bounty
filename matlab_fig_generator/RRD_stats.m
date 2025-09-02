%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Identify number of data points%%%
%%%%%%%%%%%%%%%%by Cansu Culha %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tpeak, tpeak_se, peakht, peakht_se, width, width_se, rc, rc_se, nz] = RRD_stats(filename,workdir)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 10);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["set_label", "tpeak", "tpeak_se", "peakht", "peakht_se", "width", "width_se", "rc", "rc_se", "nnz"]; %, "alt_tpeak", "alt_peakht", "alt_peakht_se"
opts.VariableTypes = ["string","double", "double", "double","double", "double", "double","double", "double", "double"];%, "double", "double","double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
cd(workdir)
dat = readtable(filename, opts);

tpeak = table2array(dat(:,"tpeak"));
tpeak_se = table2array(dat(:,"tpeak_se"));
peakht = table2array(dat(:,"peakht"));
peakht_se = table2array(dat(:,"peakht_se"));
width = table2array(dat(:,"width"));
width_se = table2array(dat(:,"width_se"));
rc = table2array(dat(:,"rc"));
rc_se = table2array(dat(:,"rc_se"));
nz = table2array(dat(:,"nnz"));


