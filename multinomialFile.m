function [ accuracy ] = multinomialFile( docFile, labelFile )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[docs, docs_label] = readFiles(docFile, labelFile);
[testFeats, testLabels] = getFeatures(docs, docs_label);

[traindocs, traindocs_label] = generateData(100);
[trainFeats, trainLabels] = getFeatures(traindocs, traindocs_label);

logFit = mnrfit(trainFeats, trainLabels);

testPred = mnrval(logFit, testFeats);
[maxProb, predLabel] = max(testPred, [], 2);
numWrong = sum(predLabel - testLabels ~= 0);
accuracy = 1 - (numWrong / length(testLabels));

end

