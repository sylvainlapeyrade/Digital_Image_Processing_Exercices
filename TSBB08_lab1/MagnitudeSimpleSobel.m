im = double(imread('circle.tif'));

figure(1)
colormap(gray(256))

cd = [1 0 -1]/2;
imdx = conv2(im, cd, 'same');
imdy = conv2(im, cd', 'same');

sobelx = [1 0 -1; 2 0 -2; 1 0 -1]/8;
imsx = conv2(im, sobelx, 'same');
imsy = conv2(im, sobelx', 'same');

gradientsx = sqrt(imsx.^2 + imsy.^2);
gradientcd = sqrt(imdx.^2 + imdy.^2);


subplot(2, 2, 1), imagesc(gradientsx,[0 160])
axis image; axis off; title('sobelgrad'); colorbar

subplot(2, 2, 2), imagesc(gradientcd,[0 160])
axis image; axis off; title('simplegrad'); colorbar


subplot(2, 2, 3), imagesc(gradientsx,[90 160])
axis image; axis off; title('sobelgrad'); colorbar

subplot(2, 2, 4), imagesc(gradientcd,[90 160])
axis image; axis off; title('simplegrad'); colorbar