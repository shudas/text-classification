function [ pred, words, boxes ] = classifyMultinomial( img, mnrfitParams )
%classifyMultinomial classifies the text in img using the multinomial fit
%parameters provided. Returns the labels and the words in the document
%   mnrfitParams should have been obtained using the same set of features
%   that will be extracted from the image.

[words, boxes] = processImage(img);
feats = getFeatures({words});
% add the height proportion of each box compared to other boxes as another feat
feats = horzcat(feats, boxes(:,1) / size(img, 2));
feats = horzcat(feats, boxes(:,2) / size(img, 1));
feats = horzcat(feats, boxes(:,4) / mean(boxes(:,4)));

pred = mnrval(mnrfitParams, feats);
[~, pred] = max(pred, [], 2);

end

