function [ connWords, combBoxes ] = combineRegions( words, boxes, maxWidth, maxHeight, onWords )
%combineRegions Combines regions for text that is in close proximity
%   The regions specified by boxes are combined. This combination happens
%   horizontally. If two regions are in close proximity horizontally, then
%   the regions and the words associated with the regions are combined with
%   a space delimiter.

% assert(length(boxes) == length(words));
connWords = {};
combBoxes = [];

if (onWords == 1)

    connIdx = 1;
    for i = 1:length(boxes) - 1
    %     add word for new line
        if (length(connWords) < connIdx)
            connWords(connIdx) = words(i);
            combBoxes(connIdx, :) = boxes(i, :);
        end
        if (containsEachOther(boxes(i, :), boxes(i + 1, :), maxWidth))
            connWords(connIdx) = strcat(connWords(connIdx), {' '}, words(i+1));
            combBoxes(connIdx, :) = combineBoxes(combBoxes(connIdx,:), boxes(i + 1,:));
        elseif (length(connWords) == connIdx)
            connIdx = connIdx + 1;
        end
    end
    return;

end

% just for returning now. Code below is for all boxes not just from ocr
% if 1==1
%     return;
% end

for i = 1:length(boxes)
    boxes(i, :) = addLeeway(boxes(i, :), maxWidth, maxHeight);
end

checkedBoxes = zeros(size(boxes, 1), 1);
connIdx = 1;
for i = 1:length(boxes) - 1
    if (checkedBoxes(i) == 1)
        continue;
    end
%     add box for new line
%     if (length(combBoxes) < connIdx)
%         'yo'
    combBoxes(connIdx, :) = boxes(i, :);
    checkedBoxes(i) = 1;
%     end
    for j = i+1:length(boxes)
        if (containsEachOther(combBoxes(connIdx, :), boxes(j, :), maxWidth))
            combBoxes(connIdx, :) = combineBoxes(combBoxes(connIdx,:), boxes(j,:));
            checkedBoxes(j) = 1;
        end
    end
    connIdx = connIdx + 1;
end

end

function [ box ] = addLeeway( region, maxWidth, maxHeight )
    mult = 0.10;
    box(1) = max(region(1) - (mult*region(4)), 1);
    box(2) = max(region(2) - (mult*region(4)), 1);
    box(3) = region(3) + (2*mult*region(4));
    box(4) = region(4) + (2*mult*region(4));
    if (box(1) + box(3) > maxWidth)
        box(3) = maxWidth - box(1);
    end
    if (box(2) + box(4) > maxHeight)
        box(4) = maxHeight - box(2);
    end
end

function [ box ] = combineBoxes( region1, region2 )
    if (region1(1) ~= region2(1))
        larger = max(region1(1), region2(1));
        if (region1(1) == larger)
            box = combineBoxes(region2, region1);
            return;
        end
    end
    left = region1(1);
    up = max(region1(2), region2(2));
    right = max(region1(1) + region1(3), region2(1) + region2(3));
    bottom = max(region1(2) + region1(4), region2(2) + region2(4));
    box = [ left, up, right - left, bottom - up ];
end

function [ contained ] = containsEachOther( region1, region2, maxWidth )
%     find the larger region vertically speaking
    if (region1(4) ~= region2(4))
        larger = max(region1(4), region2(4));
        if (region2(4) == larger)
            contained = containsEachOther(region2, region1, maxWidth);
            return;
        end
    end
    contained = false;
    mult = 0.5;
%     check that big region is contained in const multiple of the size of the smaller region
    up = region2(2) - mult * region2(4);
    down = region2(2) + region2(4) + (mult * region2(4));
%     does not fit in terms of height
    if (up > region1(2) || down < region1(2) + region1(4))
        return;
    end
    contained = horizontallyClose(region1, region2, maxWidth);
end

function [ close ] = horizontallyClose( region1, region2, maxWidth )
% after analyzing images it seems like the minimum width for a significant symbol
% like '-' is about 0.01 of the image size
minWidthFactor = 0.01;
%     find the leftmost region
    if (region1(1) ~= region2(1))
        larger = max(region1(1), region2(1));
        if (region1(1) == larger)
            close = horizontallyClose(region2, region1, maxWidth);
            return;
        end
    end
    close = false;
    % assume that ratio of text height and width is golden ratio
%     check that right region starts no later than a multiple of the width of a
%     word. Right now word width = word height
    right = region1(1) + region1(3);
    width = max(region1(4), maxWidth * minWidthFactor);
    if (region2(1) < right + width)
        close = true;
    end
end