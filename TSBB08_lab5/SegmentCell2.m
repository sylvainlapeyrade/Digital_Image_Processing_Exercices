% ################################
% Cell segmentation, preliminary 
% ################################

% Read a color image
% ==================
im1 = double(imread('C9minpeps2.bmp'));
figure(1), imshow(im1/255);
title('Original color image');

% Look at the three colour components RGB
% =======================================
im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3); 
im1bSmall = im1(200:800,200:800,3);
figure(2), imagesc(im1r,[0 255]), axis image, colormap(gray), colorbar; 
title('Red image');
figure(3), imagesc(im1g,[0 255]), axis image, colormap(gray), colorbar;
title('Green image');
figure(4), imagesc(im1b,[0 255]), axis image, colormap(gray), colorbar; 
title('Blue image');

% Compute histogram of central part of the blue image
% ===================================================
histo = hist(im1bSmall(:),[0:255]);
figure(5), stem(histo);

%% ######################################################################

% Perform thresholding
% ====================
%im1bT = im1b > 42;
T = mean(mean(im1b));
Tmid = mid_way(histo, T);
Tmid = least_error(histo,Tmid);
im1bT = im1b > Tmid;

figure(6), imagesc(im1bT), axis image, colormap(gray), colorbar;
title('After thresholding');

im1bT = bwareaopen(im1bT,800);
%im1bT = imfill(im1bT, 'holes');
% Perform opening
% ===============
SE4 = [0 1 0;
       1 1 1;
       0 1 0];
SE8 = [1 1 1;
       1 1 1;
       1 1 1];
tmp = im1bT;


tmp = imerode(tmp, SE8);
%tmp = imdilate(tmp, SE4);

tmp = im2single(tmp);
kernel = [1 2 1; 2 4 2; 1 2 1] / 16;

for k = 1:5
    tmp = conv2(tmp,kernel,'same');
end

im1bTmorph  = tmp;
figure(7), imagesc(im1bTmorph), axis image, colormap(gray), colorbar;
title('After morphological processing');

%% ######################################################################

% Compute the distance transform within the cells
% ===============================================
bw = im1bTmorph;
D = bwdist(~bw);
figure(8), imagesc(D, [0 100]); axis image, colormap(jet), colorbar;
title('Distance transform of ~bw');
colormap(jet), colorbar;

% Multiply the distance transform with -1
% and set pixels outside to the min-value.
% This is the desired landscape.
% ========================================
Dinv = -D;
Dinv(~bw) = min(min(Dinv));
Dinv = imhmin(Dinv,20);
figure(9), imagesc(Dinv), axis image, colormap(jet), colorbar;
title('Landscape 1');
colormap(jet), colorbar;


Dmin = imregionalmin(Dinv);
CC = bwconncomp(Dmin,8);
ImLabel = labelmatrix(CC);
figure(11);
imagesc(ImLabel);
W1 = watershed_meyer(Dinv,images.internal.getBinaryConnectivityMatrix(8),CC);
figure(10)
colormap(jet(256))
imagesc(W1), axis image, colormap(jet), colorbar;
title('Lables');

%%

W1b = W1 > 1;
figure(12)
colormap(jet(256))
imagesc(W1b), axis image, colormap(jet), colorbar;
title('Lables');

D = bwdist(W1b);
D(D > 100) = 0;
Dmin = imregionalmin(D);
Dmin(1,1) = 1;
CC = bwconncomp(Dmin,8);

W = watershed_meyer(D,images.internal.getBinaryConnectivityMatrix(8),CC);
figure(13), imagesc(D, [0 100]); axis image, colormap(jet), colorbar;
title('Distance transform of ~bw');
colormap(jet), colorbar;
figure(14), imagesc(W); axis image, colormap(jet), colorbar;
title('watershed');
colormap(jet), colorbar;

mask = boundarymask(W);
figure(15);
imagesc(mask);


im1 = double(imread('C9minpeps2.bmp'));
figure(16), imshow(im1/255);

% Get the three colour components RGB
% ===================================
im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3);

% Produce a mask image with an overlay pattern
% ============================================
%immask = zeros(size(im1));
M = mask;
immask = M; 

% Put the overlay pattern in magenta on the color image
% =====================================================
im2 = zeros(1000,1000,3);
im2(:,:,1) = (immask==1) .*   255 + (immask==0) .* im1r;
im2(:,:,2) = (immask==1) .*   255 + (immask==0) .* im1g;
im2(:,:,3) = (immask==1) .*   0 + (immask==0) .* im1b;

figure(17), imshow(im2/255);

%%
sobelx = [1 0 -1; 2 0 -2; 1 0 -1]/8;
sobely = [-1 -2 -1; 0 0 0; 1 2 1]/8;
sobel2 = -(conv2(sobelx,sobelx) + conv2(sobely,sobely))

label = 3;

mask = boundarymask(W==label);

M = mask;
immask = M; 

im2 = zeros(1000,1000,3);
im2(:,:,1) = (immask==1) .*   0 + (immask==0) .* im1r;
im2(:,:,2) = (immask==1) .*   255 + (immask==0) .* im1g;
im2(:,:,3) = (immask==1) .*   255 + (immask==0) .* im1b;

figure(18); imshow(im1/255); hold on;

im3f = conv2(im1r,sobel2, 'same');
%figure(19); imagesc(im3f); colormap(gray); colorbar
im3t = im3f > 25;
im3 = im3f.*im3t;
im3 = imregionalmax(im3);
sum(sum(im3))
[Y,X] = find(im3);
plot(X, Y,'co');
%figure(20); imagesc(im3); colormap(gray); colorbar

sum(sum(im3.*(W==label)))
[Y,X] = find(im3.*(W==label));
figure(21); imagesc(im2/255); hold on;
plot(X,Y,'co');