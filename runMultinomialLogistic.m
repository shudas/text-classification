function [ accuracy ] = runMultinomialLogistic( trainSize, testSize )
%runMultinomialLogistic Runs multinomial logistic regression with the given
%sizes for the training and testing data. If trainSize and testSize are not
%provided, they default to 500 and 50 respectively.

if (nargin == 0)
    trainSize = 100;
    testSize = 50;
end

logfit = train(trainSize);

[testDocs, testDocsLabels] = generateData(testSize);
[testFeats] = getFeatures(testDocs);
testLabels = convertLabels(testDocsLabels);
testPred = mnrval(logFit, testFeats);
[~, predLabel] = max(testPred, [], 2);
numWrong = sum(predLabel - testLabels ~= 0);
accuracy = 1 - (numWrong / length(testLabels));

end

