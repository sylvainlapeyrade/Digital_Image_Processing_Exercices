f = double(imread('skylt.tif')); % load image

h0 = ones(5,5)/25; % a suitable filter
h1 = 1; % a very small filter
h2 = ones (7,7)/49; % a big filter
h3 = ones (11,11)/121; % a very big filter

g = circconv(f,h3); % convolve
snr = 20;
h = addnoise(g,snr); % add noise with snr
rho = 0.80;
r = 0.01;
fhat=wiener(h,h3,snr,rho,r); % Wiener filter

figure(1), colormap(gray)
subplot(2,2,1), imagesc(f,[0 255]), axis image
title('original image'); colorbar
subplot(2,2,2), imagesc(h,[0 255]), axis image 
title('degraded image'); colorbar 
subplot(2,2,3), imagesc(fhat,[0 255]), axis image 
title('restored image'); colorbar