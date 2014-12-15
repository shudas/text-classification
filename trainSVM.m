function [ svmparams, trainFeats, trainLabels ] = trainSVM( trainSize, trainFeats, trainLabels, kernelFn )

%function [ svmparams, trainFeats, trainLabels, svmtest ] = trainSVM( trainSize, trainFeats, trainLabels, kernelFn )

%trainSVM Trains an SVM classifier with the specified training size and
%kernel function. If kernelFn is not provided, a linear kernel function is used.
%   kernelFn must be one of the ones listed at http://www.mathworks.com/help/stats/svmtrain.html.
if (nargin == 1)
    [traindocs, traindocs_label] = generateData(trainSize);
    trainFeats = getFeatures(traindocs);
    trainLabels = convertLabels(traindocs_label);
end
if (nargin < 4)
    kernelFn = 'linear';
end
% svm train works as only a binary classifier so go through all unique
% labels not equal to 1 and use them as pos samples and all others neg
differentLabels = unique(trainLabels);
differentLabels = differentLabels(differentLabels ~= 1);
svmparams = [];
svmtest = [];
for i=1:length(differentLabels)
    ones = double(trainLabels == differentLabels(i));
    ones(ones == 1) = differentLabels(i);
    
    %default parameters
    svmparams = [svmparams, svmtrain(trainFeats, ones, 'kernel_function', kernelFn)];
    
    %optimizing hyperparameters
    %svmtest = [svmtest, hyperParameterizeSVM(trainFeats, ones, kernelFn)];
end

end

