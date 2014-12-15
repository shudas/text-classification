function [ mnrparams, trainFeats, trainLabels ] = trainMultinomial( trainSize, trainFeats, trainLabels )
%trainMultinomial If sizeOrFeats is a number, generates that many training samples and runs
%multinomial regression on those. If sizeOrFeats is a matrix, then the
%matrix is interpreted as the training features.
%Returns the parameters from multinomial regression.
%   Detailed explanation goes here

if (nargin == 1)
    [traindocs, traindocs_label] = generateData(trainSize);
    trainFeats = getFeatures(traindocs);
    trainLabels = convertLabels(traindocs_label);
end

mnrparams = mnrfit(trainFeats, trainLabels);

end

