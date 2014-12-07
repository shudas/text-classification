function [ connWords ] = combineRegions( ocrText )
%combineRegions Combines regions from ocrText that are in close proximity
%   The regions of the ocrText input are combined. This combination happens
%   horizontally. If two regions are in close proximity horizontally, then
%   the regions and the words associated with the regions are combined with
%   a space delimiter.
boxes = ocrText.WordBoundingBoxes;
connWords = {};
connIdx = 1;
for i = 1:length(boxes) - 1
%     add word for new line
    if (length(connWords) < connIdx)
        connWords(connIdx) = ocrText.Words(i);
    end
    if (containsEachOther(boxes(i, :), boxes(i + 1, :)))
        connWords(connIdx) = strcat(connWords(connIdx), {' '}, ocrText.Words(i+1));
    elseif (length(connWords) == connIdx)
        connIdx = connIdx + 1;
    end
end

end

function [ contained ] = containsEachOther( region1, region2 )
%     find the larger region vertically speaking
    if (region1(4) ~= region2(4))
        larger = max(region1(4), region2(4));
        if (region2(4) == larger)
            contained = containsEachOther(region2, region1);
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
    contained = horizontallyClose(region1, region2);
end

function [ close ] = horizontallyClose( region1, region2 )
%     find the leftmost region
    if (region1(1) ~= region2(1))
        larger = max(region1(1), region2(1));
        if (region1(1) == larger)
            close = horizontallyClose(region2, region1);
            return;
        end
    end
    close = false;
    % assume that ratio of text height and width is golden ratio
%     check that right region starts no later than a multiple of the width of a
%     word. Right now word width = word height
    right = region1(1) + region1(3);
    if (region2(1) < right + region1(4))
        close = true;
    end
end