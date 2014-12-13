img = imread('raw_data/flyer069.jpg');

alpha = 'abcdefghijklmnopqrstuvwxyz';
alpha = strcat(alpha, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ');
alpha = strcat(alpha, '1234567890');
alpha = strcat(alpha, '!@#$&()-|;:''",./?');

% sharpen the image
sharpImg = img;
% sharpImg = imsharpen(img);
% fix the image by applying homography
% sharpImg = warpImage(sharpImg);
% ocr without modification
ocrOrig = ocr(sharpImg, 'CharacterSet', alpha);

% disregard words where the confidence level for that word is small and
% empty chars/strings
confThresh = 0.5;
usedWords = ocrOrig.Words(ocrOrig.WordConfidences > confThresh);
usedBoxes = ocrOrig.WordBoundingBoxes(ocrOrig.WordConfidences > confThresh, :);
nonEmpty = ~cellfun('isempty', usedWords);
usedWords = usedWords(nonEmpty);
usedBoxes = usedBoxes(nonEmpty, :);
combinedTextOrig = combineRegions(usedWords, usedBoxes, ...
    size(sharpImg, 2), size(sharpImg, 1), 1)';
imshow(sharpImg);
combinedTextOrig

% ocr with k means
% K = 4;
% 
% gray = rgb2gray(img);
% imshow(gray);
% reducedImg = kmeansFn(double(gray), K);
% colors = unique(reducedImg);
% run ocr for each of the K colors
% allWords = {};
% allBoxes = [];

% for i = 1:length(colors)
%     subImg = reducedImg == colors(i);
%     figure;
%     imshow(subImg);
%     ocrKMeans = ocr(subImg);
%     allWords = vertcat(allWords, ocrKMeans.Words);
%     allBoxes = vertcat(allBoxes, ocrKMeans.WordBoundingBoxes);
% end

% disregardWidthFactor = 0.04;
% K = 2;
% gray = rgb2gray(sharpImg);
% reducedImg = logical(kmeansFn(double(gray), K));
% % invert to see what happens
% reducedImg = imcomplement(reducedImg);
% 
% % combine adjacent regions and get rid of small width regions
% regions = regionprops(reducedImg, 'BoundingBox');
% regions = vertcat(regions.BoundingBox);
% [~, combBoxes] = combineRegions(regions, regions, size(reducedImg, 2), size(reducedImg, 1), 0);
% combBoxes = combBoxes(combBoxes(:,3) > disregardWidthFactor * size(reducedImg,2), :);
% 
% allOcrText = [];
% for i=1:length(combBoxes)
%     ocrText = ocr(reducedImg, combBoxes(i,:));
%     allOcrText = [allOcrText; ocrText];
% end
% 
% allWords = vertcat(allOcrText.Words);
% allBoxes = vertcat(allOcrText.WordBoundingBoxes);
% 
% combinedTextKMeans = combineRegions(allWords, allBoxes, size(reducedImg, 2), size(reducedImg, 1), 1)';
% imshowpair(img, reducedImg, 'montage');
