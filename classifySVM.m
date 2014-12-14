function [ pred, words ] = classifySVM( img, svmParams )
%classifySVM Classifies the words in img using the svm parameters.
%   svmParams should be an array of SVMStruct objects where each struct
%   represents the information for one label vs all other labels.
words = processImage(img);
feats = getFeatures({words});

pred = [];
for i=1:length(svmParams)
    pred = horzcat(pred, svmclassify(svmParams(i), feats));
end

end

