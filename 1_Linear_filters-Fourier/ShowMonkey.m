im = double(imread('baboon.tif'));
figure(1)
colormap(gray(256))

subplot(1,2,1), imagesc(im, [0, 255])
axis image; title('original image')
colorbar('SouthOutside')

subplot(122), imagesc(im, [50, 200])
axis image; title('contrast image')
colorbar('SouthOutside')

figure(2)
subplot(121),imagesc(im, [0 255])
axis image; title('original image')
jet('SouthOutside')


% subplot(122),imagesc(im, [50 200])
% axis image; title('contrasted image')
% colorbar('SouthOutside')

mycolormap = gray(256);
mycolormap(201:256, :, :) = ones(56,1)*[0 0 1];
mycolormap(1:51, :, :) = ones(51,1)*[0 1 0];
colormap(mycolormap)
