function [ svmStruct ] = hyperParameterizeSVM( trainFeats, trainLabels, kernelFn)

% Hyper-parameterizes using grid search (like we did in homework)
% See http://en.wikipedia.org/wiki/Hyperparameter_optimization

if (strcmp(kernelFn, 'rbf'))
    svmStruct = hyperParameterizeSVMrbf(trainFeats, trainLabels);
elseif (strcmp(kernelFn, 'linear'))
    svmStruct = hyperParameterizeSVMlinear(trainFeats, trainLabels);
else
    svmStruct = svmtrain(trainFeats, trainLabels, 'kernel_function', kernelFn);
end


end