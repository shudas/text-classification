testSize = 100;
% x = zeros(testSize, 1);
% y = zeros(testSize, 1);
x = [];
y = [];
xc = [];
yc = [];

imageSize = [8.5 11];
center = [imageSize(1)/2; imageSize(2)*3/4];
sigma = [1; 1.5];
for i=1:testSize
    boxSize = [normrnd(4, 1); normrnd(1, 0.1)];
    [xt, yt, c] = randomImageLocation(center, sigma, imageSize, boxSize);
            
    if c
        edgeColor = [0 1 0];
%         xc = [xc; xt];
%         yc = [yc; yt];
    else
        edgeColor = [1 0 0];
%         x = [x; xt];
%         y = [y; yt];
    end
    rectangle('EdgeColor', edgeColor,...
              'Position', [xt - boxSize(1)/2, yt - boxSize(2)/2,...
                            boxSize(1), boxSize(2)]);
end

% figure(1);
% plot(x, y, 'or', 'LineStyle', 'none');
% hold on;
% plot(xc, yc, 'og', 'LineStyle', 'none');
% hold off;
rectangle('Position', [0, 0, 8.5, 11]);
axis([-2 imageSize(1)+2 -2 imageSize(2)+2]);
