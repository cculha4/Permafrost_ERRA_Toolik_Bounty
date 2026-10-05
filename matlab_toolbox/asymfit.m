function paramsFit = asymfit(x,y)

% Define the hyperbolic function with asymptote
% fun = @(params, x) params(1) + params(2) ./ (x - params(3));
%sigmoid function; saturation curve often used in dissociation
%https://en.wikipedia.org/wiki/Oxygen%E2%80%93hemoglobin_dissociation_curve
fun = @(params,x) params(1)./(1+exp(-params(2).*(x-params(3))));

x = [0 x];
y = [0 y];

% Initial guess for the parameters (you may need to adjust these)
initialGuess = [0.01, 1, 0.01];

% Fit the curve using nonlinear least squares
paramsFit = lsqcurvefit(fun, initialGuess, x, y);

% Generate y values for the fitted curve
xnew = linspace(min(x),max(x),100);
yFit = fun(paramsFit, xnew);


% % Plot the original data
% plot(x, y, 'bo', 'DisplayName', 'Data');
hold on;

% Plot the fitted curve
plot(xnew, yFit, 'r-', 'DisplayName', 'Fitted Curve','LineWidth',2);



% Display the fitted parameters
fprintf('Fitted Parameters:\n');
fprintf('A = %.2f\n', paramsFit(1));
fprintf('B = %.2f\n', paramsFit(2));
fprintf('C (Asymptote) = %.2f\n', paramsFit(3));