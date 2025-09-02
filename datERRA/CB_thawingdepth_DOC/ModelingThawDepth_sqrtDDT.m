%%%%% Modeling Thaw Depth using DDT%%%%%%%%%%%%%%
function [Z, dZ] = ModelingThawDepth_sqrtDDT(time,months,temp)

cs_T = cumsum(temp);
DDT = zeros(size(temp));

for ll = 2:numel(temp)
    if months(ll) == 4
        DDT(ll) = 0;
        continue
    end
    
    if temp(ll) > 0
       DDT(ll) = DDT(ll-1) + temp(ll);
    else
        DDT(ll) = DDT(ll-1) + 0;
    end
end
figure;
plot(time, 2.5*sqrt(DDT),'.k','MarkerSize',25)
hold on
% plot(DepthAL.t_,DepthAL.depthAL_trim,'or','LineWidth',3)

%create a transparent white box to hide the data that is in the freezing
%time period

% Define the periods for September to March for each year in your data
startYear = floor(min(time));
endYear = ceil(max(time));

for year = startYear:endYear
    % Convert September to March into decimal format for the given year
    sep = datenum(year, 9, 1);
    mar = datenum(year + 1, 3, 31);
    
    % Convert dates from datenum to decimal year
    sep_dec = decyear(sep); %year + (sep - datenum(year, 1, 1)) / 365.25;
    mar_dec = decyear(mar); %year + 1 + (mar - datenum(year + 1, 1, 1)) / 365.25;
    
    % Add a patch (transparent white box) for September to March
    % Assuming the y-axis limits cover the range of your data
    yl = [min(2.5*sqrt(DDT)) max(2.5*sqrt(DDT))]; % Get current y-axis limits
    patch([sep_dec, mar_dec, mar_dec, sep_dec], [yl(1), yl(1), yl(2), yl(2)], 'w', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
end



% Adjusting the x-axis to display years more clearly if needed
% datetick('x', 'yyyy','keeplimits'); % This line is more illustrative; it doesn't directly apply to decimal years but hints at how you might want to format the axis.








Z = [2.5*sqrt(DDT') 0];

dZ = Z(2:end)-Z(1:end-1);





