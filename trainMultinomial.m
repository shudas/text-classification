function [ mnrparams ] = trainMultinomial( trainSize )
%trainMultinomial Generates trainSize number of training samples and runs
%multinomial regression on those. Returns the parameters from multinomial
%regression.
%   Detailed explanation goes here

[traindocs, traindocs_label] = generateData(trainSize);
feats = getFeatures(traindocs);
trainLabels = convertLabels(traindocs_label);
mnrparams = mnrfit(feats, trainLabels);

end

