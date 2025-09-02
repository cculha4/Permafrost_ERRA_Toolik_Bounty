function [maxRRD,maxRRDlgt,maxRRDse, RRD_p,se_p,lagt] = figtRRD_plot_years_thaw(filename,workdir,Colors,hourlimit,hourrange,choice)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%Load data here%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 3);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = "\t";

% Specify column names and types
opts.VariableNames = ["lagtime", "RRD_P1all",  "RRD_dw1all","se_P1all","se_dw1all"];
opts.VariableTypes = ["double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
cd(workdir)
dat = readtable(filename, opts);

lagt = table2array(dat(:,"lagtime"));
RRD_p = table2array(dat(:,"RRD_P1all"));
se_p = table2array(dat(:,"se_P1all"));
RRD_dw = table2array(dat(:,"RRD_dw1all"));
se_dw = table2array(dat(:,"se_dw1all"));

if choice == "P"
    RRD = RRD_p;
    se = se_p;
elseif choice == "T"
    RRD = RRD_dw;
    se = se_dw;
end

if hourlimit
    index = (lagt>=hourrange(1) & lagt<=hourrange(2));
    maxRRD = max(RRD(index));
    minRRD = min(RRD(index));
    index_lagt = RRD ==maxRRD;
    maxRRDlgt = lagt(index_lagt);
    maxRRDse = se(index_lagt);
else
    maxRRD = max(RRD);
    minRRD = min(RRD);
    index_lagt = RRD ==maxRRD;
    maxRRDlgt = lagt(index_lagt);
    maxRRDse = se(index_lagt);
end

%Plot figure
hold on
e = errorbar(lagt,RRD,se,'-','LineWidth',6,'MarkerSize',25,'Color',Colors);
e.CapSize = 0;