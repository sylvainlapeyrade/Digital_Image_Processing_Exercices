im = double(imread('circle.tif'));

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255])
axis image; axis off; title('original image'); colorbar

cd = [1 0 -1]/2;
imdx = conv2(im,cd,'same');
subplot(2,2,3), imagesc(imdx, [-128 127])
axis image; axis off; title('sobelx image'); colorbar

cd2 = [1; 0; -1]/2;
imdy = conv2(im,cd2,'same');
subplot(2,2,4), imagesc(imdy, [-128 127])
axis image; axis off; title('sobely image'); colorbar

cd3 = conv(cd, cd);
cd4 = conv2(cd2, cd2);
imdx2 = conv2(im, cd3,'same');
imdy2 = conv2(im, cd4,'same');

magngrad =  sqrt(pow2(imdx2) + pow2(imdy2));
subplot(2,2,2), imagesc(magngrad, [0 150])
axis image; axis off; title('magngrad image'); colorbar