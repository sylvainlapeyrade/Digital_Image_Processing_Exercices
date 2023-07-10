% Read a color image and convert to a gray-scale image
% ====================================================
[X,map] = imread('corn.tif');
newmap = rgb2gray(map);
corn = ind2gray(X,newmap);
im1gray = double(corn);

figure(1), imagesc(im1gray,[0 255]), colormap(gray), colorbar,
title('Original image');

% Negate the image
% =================
im2gray = double(255-im1gray);
figure(2), imagesc(im2gray,[0 255]), colormap(gray), colorbar;
title('negated image (landscape)');

% Prepare for smoothing
% =====================
kernel = [1 2 1; 2 4 2; 1 2 1] / 16;
D = im2gray;
k=1;
while k<5
    D = conv2(D, kernel, 'same');
    k = k+1;
end

figure(3), imagesc(D);
colormap(gray), colorbar;
title('Smoothed image (landscape)');

% Perform watershed transform
% ===========================
W = double(watershed(D));
figure(4), imagesc(W);
colormap(colorcube(300)), colorbar;
title('Watershed transform of D')

% Search local min and find connected components
% ==============================================
Dmin = imregionalmin(D); 
CC = bwconncomp(Dmin,8);
ImLabel = labelmatrix(CC);
figure(5), imagesc(ImLabel);
colormap(colorcube(300)), colorbar;
title('Local means (water holes)')

%% Perform watershed transformation
% ================================
W1 = watershed_meyer(im2gray,images.internal.getBinaryConnectivityMatrix(8),CC);
%W1 = watershed_meyer(D,images.internal.getBinaryConnectivityMatrix(8),CC);
figure(7), imagesc(W1);
title('Watershed meyer transform')
colormap(colorcube(300)), colorbar;
