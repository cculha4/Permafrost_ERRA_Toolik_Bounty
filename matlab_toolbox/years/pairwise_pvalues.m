function pValueMatrix = pairwise_pvalues(VarParameters, maxRRD)
    % Number of parameters (assuming VarParameters is [nObservations x nPredictors])
    numPredictors = size(VarParameters, 2);
    
    % Initialize matrix to store p-values
    pValueMatrix = zeros(numPredictors, numPredictors);
    
    % Loop through all combinations of predictors
    for i = 1:numPredictors
        for j = 1:numPredictors
            % Combine the i-th and j-th predictors into a model
            predictors = [VarParameters(:, i), VarParameters(:, j)];
            
            % Fit a linear model with the two predictors
            mdl = fitlm(predictors, maxRRD);
            
            % Extract p-values for the two predictors (ignoring the intercept)
            pVals = mdl.Coefficients.pValue(2:end);  % Skip intercept p-value
            
            % Store the larger p-value in the matrix (we want to penalize both)
            pValueMatrix(i, j) = max(pVals);
        end
    end
    
    % Find the indices of the minimum p-value in the matrix
    [bestPValue, idx] = min(pValueMatrix(:));  % Find the smallest p-value
    [row, col] = ind2sub(size(pValueMatrix), idx);  % Convert linear index to row and column
    
    % Best pair of parameters
    bestPair = [row, col];
    
    % Display the matrix of p-values and the best combination
    disp('Matrix of p-values for all pairwise combinations of predictors:');
    disp(pValueMatrix);
    
    disp('Best pair of predictors with the smallest p-value:');
    disp(['Predictor ', num2str(row), ' and Predictor ', num2str(col)]);
    disp(['Smallest p-value: ', num2str(bestPValue)]);
end
