function [ pred, words, boxes ] = classifySVM( img, svmParams )
%classifySVM Classifies the words in img using the svm parameters.
%   svmParams should be an array of SVMStruct objects where each struct
%   represents the information for one label vs all other labels.
[words, boxes] = processImage(img);
feats = getFeatures({words});
% add the height proportion of each box compared to other boxes as another feat
feats = horzcat(feats, boxes(:,1) / size(img, 2));
feats = horzcat(feats, boxes(:,2) / size(img, 1));
feats = horzcat(feats, boxes(:,4) / mean(boxes(:,4)));

pred = [];
for i=1:length(svmParams)
    pred = horzcat(pred, svmclassify(svmParams(i), feats));
end

end

