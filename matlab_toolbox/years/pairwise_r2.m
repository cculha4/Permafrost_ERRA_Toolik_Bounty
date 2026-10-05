function [rSquaredMatrix, bestPair, bestR2] = pairwise_r2(VarParameters, maxRRD)
    % Number of parameters (assuming VarParameters is [nObservations x nPredictors])
    numPredictors = size(VarParameters, 2);
    
    % Initialize matrix to store R-squared values
    rSquaredMatrix = zeros(numPredictors, numPredictors);
    
    % Loop through all combinations of predictors
    for i = 1:numPredictors
        for j = 1:numPredictors
            % Combine the i-th and j-th predictors into a model
            predictors = [VarParameters(:, i), VarParameters(:, j)];
            
            % Fit a linear model with the two predictors
            mdl = fitlm(predictors, maxRRD);
            
            % Extract the R-squared value from the model
            rSquaredMatrix(i, j) = mdl.Rsquared.Ordinary;  % Store the R^2 value
        end
    end
    
    % Find the indices of the maximum R-squared value in the matrix
    [bestR2, idx] = max(rSquaredMatrix(:));  % Find the largest R^2 value
    [row, col] = ind2sub(size(rSquaredMatrix), idx);  % Convert linear index to row and column
    
    % Best pair of parameters
    bestPair = [row, col];
    
    % Display the matrix of R-squared values and the best combination
    disp('Matrix of R-squared values for all pairwise combinations of predictors:');
    disp(rSquaredMatrix);
    
    disp('Best pair of predictors with the highest R-squared value:');
    disp(['Predictor ', num2str(row), ' and Predictor ', num2str(col)]);
    disp(['Highest R-squared value: ', num2str(bestR2)]);
end
