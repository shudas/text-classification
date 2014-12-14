function [ words ] = processImage( img )
%processImg Runs ocr and post processing on img. Returns a cell array of
%the extracted words

% the ocr alphabet
alpha = 'abcdefghijklmnopqrstuvwxyz';
alpha = strcat(alpha, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
alpha = strcat(alpha, '1234567890');
alpha = strcat(alpha, '!@#$&()-|;:''",./?');

% ocr without modification
ocrOrig = ocr(img, 'CharacterSet', alpha);

% disregard words where the confidence level for that word is small and
% empty chars/strings
confThresh = 0.5;
usedWords = ocrOrig.Words(ocrOrig.WordConfidences > confThresh);
usedBoxes = ocrOrig.WordBoundingBoxes(ocrOrig.WordConfidences > confThresh, :);
usedWords = strtrim(usedWords);
nonEmpty = ~cellfun('isempty', usedWords);
usedWords = usedWords(nonEmpty);
usedBoxes = usedBoxes(nonEmpty, :);
words = combineRegions(usedWords, usedBoxes, ...
    size(img, 2), size(img, 1), 1)';

end

