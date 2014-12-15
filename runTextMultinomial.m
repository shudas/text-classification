function [ accuracy ] = multinomialFile( docFile, labelFile )
%UNTITLED Runs multinomial regression with the document folder and label
%folder provided. Generates 100 random training data points
%   Detailed explanation goes here

logFit = train(100);

[docs, docs_label] = readFiles(docFile, labelFile);
[testFeats] = getFeatures(docs);
testLabels = convertLabels(docs_label);

testPred = mnrval(logFit, testFeats);
[~, predLabel] = max(testPred, [], 2);
numWrong = sum(predLabel - testLabels ~= 0);
accuracy = 1 - (numWrong / length(testLabels));

end

