function [ reducedImage, mu ] = kmeansFn( img, K )
ab = img;
if (size(img, 3) == 3)
    ab = prepareRGB(img);
%     init = selectInitPointsAvg(img, K);
end
% flatImg = double(reshape(img,size(img,1)*size(img,2),size(img,3)));
ab = double(reshape(img, size(img,1)*size(img,2),size(img,3)));
[idx, mu] = kmeans(ab, 2, 'Start', [0;1]);
% [idx, mu] = kmeans(ab, K, 'Start', init);

assign = reshape(idx,size(img,1),size(img,2));
reducedImage = mat2gray(assign);

end

function [ initPoints ] = selectInitPointsAvg( img, K )
    ab = prepareRGB(img);
    J = 10;
    compressedData = [];
    for i=1:J
        sample = datasample(ab, round(length(ab) / 100));
        [idx, mu] = kmeans(sample, K);
        compressedData = [compressedData; mu(idx, :)];
    end
    [~, initPoints] = kmeans(compressedData, K);
end

function [ initPoints ] = selectInitPoints( img, K )
    partitionStore = [];
    for i=1:size(img, 3)
        sorted = sort(reshape(img(:,:,i), size(img, 1)*size(img, 2), 1));
        partitions = reshape(sorted,length(sorted)/K,K,size(sorted,2));
        partitionStore(:,i) = median(partitions);
    end
    for i=1:K
        for j=1:size(img, 3)
            initPoints(i,1,j) = partitionStore(randi(size(partitionStore,1)), j);
        end
    end
end

function [ ab ] = prepareRGB( img )
    cform = makecform('srgb2lab');
    labImg = applycform(img,cform);
    ab = double(labImg(:,:,2:3));
    ab = reshape(ab, size(ab,1)*size(ab,2), 2);
end