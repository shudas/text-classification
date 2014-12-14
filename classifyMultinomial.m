function [ pred, words ] = classifyMultinomial( img, mnrfitParams )
%classifyMultinomial classifies the text in rgbImg image using the multinomial fit
%parameters provided. Returns the words from the document and the associated labels
%   mnrfitParams should have been obtained using the same set of features
%   that will be extracted from the image.

words = processImage(img);
feats = getFeatures({words});
pred = mnrval(mnrfitParams, feats);
[~, pred] = max(pred, [], 2);

end

