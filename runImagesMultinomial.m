function [ allPred, allWords, allBoxes] = runImagesMultinomial( useNewTrainingData )
%UNTITLED Runs multinomial regression on all images in data directory as
%test data. Image directory must be called 'data'
%   Detailed explanation goes here

% try to use already generated training features
trainFeatsFileName = 'STORED_TRAINING_FEATS.txt';
trainLabelFileName = 'STORED_TRAINING_LABELS.txt';
mnrparams = 0;
if useNewTrainingData
    trainSize = 10;
    [mnrparams, trainFeats, trainLabels] = trainMultinomial(10);
%     write the features to text file for future use
    dlmwrite(trainFeatsFileName, trainFeats);
    dlmwrite(trainLabelFileName, trainLabels);
else
    try
        trainFeats = dlmread(trainFeatsFileName);
        trainLabels = dlmread(trainLabelFileName);
        mnrparams = trainMultinomial(0, trainFeats, trainLabels);
    catch
%         the file wasnt found so generate new data and store it to file
        fprintf('Could not read stored training feature and label files. New training data will be generated.\n');
        runImagesMultinomial(true);
    end
end

workingImages = {'flyer010.jpg', 'flyer018.png', 'flyer020.jpg', 'flyer028.jpg', 'flyer029.jpg', 'flyer032.jpg', 'flyer034.jpg', 'flyer035.jpg'};

allPred = {};
allWords = {};
allBoxes = {};
for i=1:length(workingImages)
    file = workingImages{i};
    img = '';
    try
        img = imread(strcat('data/', file));
    catch
        continue;
    end
    
    [pred, words, boxes] = classifyMultinomial(img, mnrparams);
    allWords{length(allWords) + 1} = words;
    allBoxes{length(allBoxes) + 1} = boxes;
    allPred{length(allPred) + 1} = pred;
end
end

