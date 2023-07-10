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
T = mean(mean(im1b));
Tmid = mid_way(histo, T);
Tmid = least_error(histo,Tmid);
im1bT = im1b > Tmid;
%im1bT = im1b > 42;

figure(6), imagesc(im1bT), axis image, colormap(gray), colorbar;
title('After thresholding');

% Remove small objects from binary image
im1bT = bwareaopen(im1bT, 1000);

% Perform opening
% ===============
SE4 = [0 1 0; 1 1 1; 0 1 0];
SE8 = [1 1 1; 1 1 1; 1 1 1];
   
tmp = im1bT;
%tmp = imerode(tmp, SE4);
%tmp = imdilate(tmp, SE4);
tmp = imerode(tmp, SE8);
tmp = imdilate(tmp, SE8);

%Convert image to single precision, rescaling the data
tmp = im2single(tmp);
kernel = [1 2 1; 2 4 2; 1 2 1] / 16;

% Multiple convolution
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
figure(8), imagesc(D, [0, 100]); axis image, colormap(jet), colorbar;
title('Distance transform of ~bw');
colormap(jet), colorbar;

% Multiply the distance transform with -1
% and set pixels outside to the min-value.
% This is the desired landscape.
% ========================================
Dinv = -D;
Dinv(~bw) = min(min(Dinv));
% Suppresses all minima in the grayscale image
Dinv = imhmin(Dinv,20);
figure(9), imagesc(Dinv), axis image, colormap(jet), colorbar;
title('Landscape 1');

% Search local min and find connected components
% ==============================================
Dmin = imregionalmin(Dinv); 
CC = bwconncomp(Dmin,8);
ImLabel = labelmatrix(CC);
figure(10), imagesc(ImLabel);
axis image, colormap(jet), colorbar;
title('Local means (water holes)')

% Perform watershed transformation
% ================================
W1 = watershed_meyer(Dinv,images.internal.getBinaryConnectivityMatrix(8),CC);
figure(11), imagesc(W1); axis image, colormap(jet), colorbar;
title('Watershed meyer transform')

% 
W1b = W1 > 1;
figure(12), imagesc(W1b), axis image, colormap(jet), colorbar;
title('Value > 1');

% Compute the distance transform within the cells
% ===============================================
D = bwdist(W1b); 
D(D > 100) = 0;
figure(13), imagesc(D, [0 100]); axis image, colormap(jet), colorbar;
title('Distance transform of W1b');

% Identifies the regional minima in image
Dmin = imregionalmin(D); 
Dmin(1,1) = 1;
% Find connected components in binary image
CC = bwconncomp(Dmin,8);
figure(50), imagesc(Dmin);

% Perform watershed transformation
% ================================
W = watershed_meyer(D,images.internal.getBinaryConnectivityMatrix(8),CC);
figure(14), imagesc(W); axis image, colormap(jet), colorbar;
title('Watershed meyer transform')


% Read a colour image
% ===================
%im1 = double(imread('C9minpeps2.bmp'));
%figure(15), imshow(im1/255);

% Get the three colour components RGB
% ===================================
%im1r=im1(:,:,1); im1g=im1(:,:,2); im1b=im1(:,:,3);

% Produce a mask image with an overlay pattern
% ============================================
% immask = zeros(1000,1000);
% M = [ 1 1 0 0 0 0 0 0 0 0 1 1;
%       1 1 1 0 0 0 0 0 0 1 1 1;
%       1 1 1 1 0 0 0 0 1 1 1 1;
%       1 1 0 1 1 0 0 1 1 0 1 1;
%       1 1 0 0 1 1 1 1 0 0 1 1;
%       1 1 0 0 0 1 1 0 0 0 1 1;
%       1 1 0 0 0 0 0 0 0 0 1 1;
%       1 1 0 0 0 0 0 0 0 0 1 1;
%       1 1 0 0 0 0 0 0 0 0 1 1;
%       1 1 0 0 0 0 0 0 0 0 1 1;
%       1 1 0 0 0 0 0 0 0 0 1 1;
%       1 1 0 0 0 0 0 0 0 0 1 1];
% immask(500:511,500:511) = M

% Computes mask representing the region boundaries
immask = boundarymask(W);
figure(16); imagesc(immask);
title('Boundary Mask')

% Put the overlay pattern in yellow on the color image
% =====================================================
im2 = zeros(1000,1000,3);
im2(:,:,1) = (immask==1) .* 255 + (immask==0) .* im1r;
im2(:,:,2) = (immask==1) .* 255 + (immask==0) .* im1g;
im2(:,:,3) = (immask==1) .* 0 + (immask==0) .* im1b;

figure(17), imshow(im2/255);
title('Yellow Boundary Mask for cell cytoplasm')

% Localization of padlock-signals
sobelx = [1 0 -1; 2 0 -2; 1 0 -1]/8;
sobely = [-1 -2 -1; 0 0 0; 1 2 1]/8;
neg_lapl_filter = -(conv2(sobelx,sobelx) + conv2(sobely,sobely))
% Negative laplacian filter :
%   [-0.0313   -0.0625   -0.0625   -0.0625   -0.0313
%    -0.0625         0    0.1250         0   -0.0625
%    -0.0625    0.1250    0.3750    0.1250   -0.0625
%    -0.0625         0    0.1250         0   -0.0625
%    -0.0313   -0.0625   -0.0625   -0.0625   -0.0313]

figure(18); imshow(im1/255); hold on;
title('Red padlocks signals')

im1r = double(im1r);

im3f = 100*conv2(im1r,neg_lapl_filter, 'same');
im3t = im3f > 30;
im3 = im3f.*im3t;

figure(51); imagesc(im3f); axis image; colorbar; colormap(jet)

% Identifies the regional maxima in image
im3 = imregionalmax(im3);
% Total number of red padlock signals
sum(sum(im3))
[Y,X] = find(im3);
plot(X, Y,'co');

% Number of red padlock in selected cell
sum(sum(im3.*(W==6)))
[Y,X] = find(im3.*(W==6));
figure(19); imagesc(im2/255); hold on;
plot(X,Y,'co'); 
