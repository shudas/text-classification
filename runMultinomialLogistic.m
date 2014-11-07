function [ accuracy ] = runMultinomialLogistic( trainSize, testSize )
%runMultinomialLogistic Runs multinomial logistic regression with the given
%sizes for the training and testing data. If trainSize and testSize are not
%provided, they default to 500 and 50 respectively.

if (nargin == 0)
    trainSize = 100;
    testSize = 50;
end

[trainDocs, trainDocsLabels] = generateData(trainSize);
[trainFeats, trainLabels] = getFeatures(trainDocs, trainDocsLabels);

logFit = mnrfit(trainFeats, trainLabels);

[testDocs, testDocsLabels] = generateData(testSize);
[testFeats, testLabels] = getFeatures(testDocs, testDocsLabels);

testPred = mnrval(logFit, testFeats);
[maxProb, predLabel] = max(testPred, [], 2);
numWrong = sum(predLabel - testLabels ~= 0);
accuracy = 1 - (numWrong / length(testLabels));

end

