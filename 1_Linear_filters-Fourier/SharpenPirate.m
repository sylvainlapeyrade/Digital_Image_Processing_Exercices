load('pirat.mat')
im = pirate;

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255])
axis image; axis off; title('original image')
colorbar('SouthOutside')
laplace = [0 1 0; 1 -4 1; 0 1 0];
imlaplace = conv2(im, laplace, 'same');
subplot(2,2,2), imagesc(imlaplace, [-200 200])
axis image; axis off; title('Laplace image')
colorbar('SouthOutside')

subplot(2,2,3), imagesc(im-imlaplace, [0 255])
axis image; title('sharp image')
colorbar('SouthOutside')

subplot(2,2,4), imagesc(im-2*imlaplace, [0 255])
axis image; title('sharp image2')
colorbar('SouthOutside')