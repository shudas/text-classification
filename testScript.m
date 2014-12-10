img = imread('raw_data/flyer051.jpg');
% sharpen the image
sharpImg = imsharpen(img);
% ocr without modification
ocrOrig = ocr(sharpImg);
combinedTextOrig = combineRegions(ocrOrig.Words, ocrOrig.WordBoundingBoxes,...
    size(sharpImg, 2), size(sharpImg, 1), 1)';

% ocr with k means
% K = 4;
% 
% gray = rgb2gray(img);
% imshow(gray);
% reducedImg = kmeansFn(double(gray), K);
% colors = unique(reducedImg);
% run ocr for each of the K colors
allWords = {};
allBoxes = [];

% for i = 1:length(colors)
%     subImg = reducedImg == colors(i);
%     figure;
%     imshow(subImg);
%     ocrKMeans = ocr(subImg);
%     allWords = vertcat(allWords, ocrKMeans.Words);
%     allBoxes = vertcat(allBoxes, ocrKMeans.WordBoundingBoxes);
% end


disregardWidthFactor = 0.04;
K = 2;
gray = rgb2gray(sharpImg);
reducedImg = logical(kmeansFn(double(gray), K));
% invert to see what happens
reducedImg = imcomplement(reducedImg);

% combine adjacent regions and get rid of small width regions
regions = regionprops(reducedImg, 'BoundingBox');
regions = vertcat(regions.BoundingBox);
[~, combBoxes] = combineRegions(regions, regions, size(reducedImg, 2), size(reducedImg, 1), 0);
combBoxes = combBoxes(combBoxes(:,3) > disregardWidthFactor * size(reducedImg,2), :);

allOcrText = [];
for i=1:length(combBoxes)
    ocrText = ocr(reducedImg, combBoxes(i,:));
    allOcrText = [allOcrText; ocrText];
end

allWords = vertcat(allOcrText.Words);

% combinedTextKMeans = combineRegions(allWords, allBoxes)';
% imshowpair(img, reducedImg, 'montage');
