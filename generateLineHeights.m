function [ title_height, other_line_heights ] = generateLineHeights( num_lines )
%generates line heights for all lines in a document.
%line heights are generated based on random chi squared distribution
%samples
%title_height is one of the greatest valued of the generated chi squared
%values

title_height = 0;
other_line_heights = chi2rnd(4,num_lines,1);
meanHeight = mean(other_line_heights);
stdDev = std(other_line_heights);
veryLargeOnes = nan(num_lines,1);
largeOnes = nan(num_lines,1);
notAsLargeOnes = nan(num_lines,1);
aboveAverageOnes = nan(num_lines,1);
for i = 1:num_lines
    if(other_line_heights(i,1) > (meanHeight + 2*stdDev))
        veryLargeOnes(i,1) = other_line_heights(i,1);
    end
    if (other_line_heights(i,1) > (meanHeight + stdDev))
        largeOnes(i,1) = other_line_heights(i,1);
    end
    if (other_line_heights(i,1) > (meanHeight + 0.5*stdDev))
        notAsLargeOnes(i,1) = other_line_heights(i,1);
    end
    if (other_line_heights(i,1) > meanHeight)
        aboveAverageOnes(i,1) = other_line_heights(i,1);
    end
end
veryLargeOnes = veryLargeOnes(~isnan(veryLargeOnes(:,1)),1);
largeOnes = largeOnes(~isnan(largeOnes(:,1)),1);
notAsLargeOnes = notAsLargeOnes(~isnan(notAsLargeOnes(:,1)),1);
aboveAverageOnes = aboveAverageOnes(~isnan(aboveAverageOnes(:,1)),1);
if (~isempty(veryLargeOnes))
    arraySize = size(veryLargeOnes,1);
    title_height = veryLargeOnes(randi(arraySize),1);
elseif (~isempty(largeOnes))
    arraySize = size(largeOnes,1);
    title_height = largeOnes(randi(arraySize),1);
elseif (~isempty(notAsLargeOnes))
    arraySize = size(notAsLargeOnes,1);
    title_height = notAsLargeOnes(randi(arraySize),1);
else
    arraySize = size(aboveAverageOnes,1);
    title_height = aboveAverageOnes(randi(arraySize),1);
end
title_height = title_height/meanHeight;
other_line_heights = other_line_heights./meanHeight;
trimmedLineHeights = zeros(num_lines - 1,0);
doubleCheck = 0;
j = 1;
for i = 1:num_lines
    if(other_line_heights(i,1) == title_height && ~doubleCheck)
        doubleCheck = 1;
    else
        trimmedLineHeights(j,1) = other_line_heights(i,1);
        j = j+1;
    end
end
other_line_heights = trimmedLineHeights;
end