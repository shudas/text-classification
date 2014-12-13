function [ mus, indices ] = dynamicKMeans( inputRGB, threshold )
%dynamicKMeans Runs K means but selects K dynamically based on the
%threshold provided. Currently works with RGB images only
%   If the normalized distance b/t 2 adjacent points is below the 
%   threshold, those points are considered to be in the same cluster.

assert(ndims(inputRGB) == 3);
inputRGB = double(inputRGB);

TOTAL = 3*(255^2);

mus = [];
numPerMu = [];
indices = zeros(size(inputRGB,1), size(inputRGB,2));

% set the first point to equal index 1
mus(1,:) = inputRGB(1,1,:);
numPerMu(1) = 1;
indices(1,1) = 1;

for i = 1:size(inputRGB, 1)
    for j = 1:size(inputRGB, 2)
        currPoint = reshape(inputRGB(i,j,:), size(inputRGB, 3), 1)';
        bestCluster = 0;
        bestThresh = inf;
        for k = 1:size(mus, 1)
            newThresh = (sum((currPoint - mus(k,:)).^2)) / TOTAL;
            if (newThresh < bestThresh && newThresh < threshold)
                bestThresh = newThresh;
                bestCluster = k;
            end
        end
%         no current averages were close so create a new avg
        if (bestCluster == 0)
            mus(size(mus, 1) + 1, :) = currPoint;
            indices(i,j) = size(mus, 1);
            numPerMu(size(mus, 1)) = 1;
        else
            indices(i,j) = bestCluster;
%            update the mu
            mus(bestCluster, :) = (mus(bestCluster, :) * numPerMu(bestCluster)...
                + currPoint) / (numPerMu(bestCluster) + 1);
            numPerMu(bestCluster) = numPerMu(bestCluster) + 1;
        end
        if (i == 742 && j == 492)
            currPoint
            bestCluster
            size(mus, 1)
            indices(i,j)
        end
    end
end

end

