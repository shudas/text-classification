function [ warped, newCorners ] = warpImage( image )
%warpImage Warps the input image so that it becomes rectangular
%   This code was found on a thread online. Original code written by 
%   Teja Muppirala on http://www.mathworks.com/matlabcentral/answers/66123-matlab-find-the-contour-and-straighten-a-nearly-rectangular-image

%% 1. Get rid of the white border
I = image;
I2 = imclearborder(im2bw(I));
%% 2. Find each of the four corners
[y,x] = find(I2);
[~,loc] = min(y+x);
C = [x(loc),y(loc)];
[~,loc] = min(y-x);
C(2,:) = [x(loc),y(loc)];
[~,loc] = max(y+x);
C(3,:) = [x(loc),y(loc)];
[~,loc] = max(y-x);
C(4,:) = [x(loc),y(loc)];
%% 3. Find the locations of the new  corners
L = mean(C([1 4],1));
R = mean(C([2 3],1));
U = mean(C([1 2],2));
D = mean(C([3 4],2));
newCorners = [L U; R U; R D; L D];
%% 4. Do the image transform
T = fitgeotrans(C, newCorners, 'projective');
warped = imwarp(I,T);

end

