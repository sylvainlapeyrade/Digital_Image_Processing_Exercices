im = double(imread('baboon.tif'));

figure(1)
colormap(gray(256))
subplot(1,2,1), imagesc(im, [0 255])
axis image; title('original image')
colorbar('SouthOutside')

aver = [1 2 1; 2 4 2; 1 2 1] /16;
imaver = conv2(im,aver,'valid');
%imaver = conv2(conv2(conv2(im,aver,'same'), aver, 'same'), aver, 'same');

subplot(122), imagesc(imaver, [0, 255])
axis image; title('convolved image')
colorbar('SouthOutside')