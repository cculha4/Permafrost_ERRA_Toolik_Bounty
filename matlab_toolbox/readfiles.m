function dataout = readfiles(filename)


opts = delimitedTextImportOptions("NumVariables", 13);

% Specify range and delimiter
opts.DataLines = [2, Inf];
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["time_cont", "years", "months", "airtemp", "P", "Q", "ThawDepth", "dZ", "dw30", "DOC", "POC", "SSC","TDS"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double","double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Import the data
dataout = readtable(filename, opts);
