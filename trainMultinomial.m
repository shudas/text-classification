function [ mnrparams ] = train( trainSize )
%UNTITLED3 Generates trainSize number of training samples and runs
%multinomial regression on those. Returns the parameters from multinomial
%regression.
%   Detailed explanation goes here

[traindocs, traindocs_label] = generateData(trainSize);
feats = getFeatures(traindocs);
labels = convertLabels(traindocs_label);
mnrparams = mnrfit(feats, labels);

end
