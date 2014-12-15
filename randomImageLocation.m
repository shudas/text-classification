% center is a row vector for x and y coords
% sigma is a row vector for x stdev and y stdev
% imageSize is a row vector for width and height of the image
% box Size is a row vector for width and height for the bounding box
% changed is used for testing
function [x, y, changed] = randomImageLocation(center, sigma, imageSize, boxSize)
    x = normrnd(center(1), sigma(1));
    y = normrnd(center(2), sigma(2));
    changed = false;

    if x - (boxSize(1)/2) < 0
        x = boxSize(1)/2;
        changed = true;
    end
    
    if x + (boxSize(1)/2) > imageSize(1)
        x = (imageSize(1)) - (boxSize(1)/2);
        changed = true;
    end
    
    if y - (boxSize(2)/2) < 0
        y = boxSize(2)/2;
        changed = true;
    end
    
    if y + (boxSize(2)/2) > imageSize(2)
        y = (imageSize(2)) - (boxSize(2)/2);
        changed = true;
    end
end