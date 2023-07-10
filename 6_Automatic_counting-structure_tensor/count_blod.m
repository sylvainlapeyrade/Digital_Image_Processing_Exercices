%% Hysteresis
blod = double(imread('blod256.tif'));
binvect = [0:1:255];
histo = hist(blod(:), binvect);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(blod, [0 255]); axis image;
title('image nuf0c'); colorbar
subplot(2,2,2), plot(binvect, histo, '.-b'); axis tight;
title('histogram')

thresh_blod = blod > 60;
subplot(2,2,3), imagesc(thresh_blod);
axis image; title('after threshold 1'); colorbar

thresh_blod_open = bwareaopen(thresh_blod,17);
thresh_blod_dilate = imdilate(thresh_blod_open,SE8);

blod_fill = imfill(thresh_blod_dilate,8,'holes');
subplot(122); imagesc(blod_fill); axis image;

CC = bwconncomp(blod_fill);
blod_label = labelmatrix(CC);

figure(3);
colormap(colorcube(300));
imagesc(blod_label); axis image; colorbar;

blod_shrink = bwmorph(blod_label,'shrink',Inf);
figure(4);
colormap(colorcube(300));
imagesc(blod_shrink); axis image; colorbar;
disp(['Blood Cells:  ', num2str(sum(sum(blod_shrink)))])

resultim = zeros(256,256,3);
resultim(:,:,1) = (blod_shrink==1).*255+(blod_shrink==0).*blod;
resultim(:,:,2) = blod;
resultim(:,:,3) = blod;
figure(99), imshow(resultim/255);

%% Correlation
blod = double(imread('blod256.tif'));
pattern = blod(25:25+19, 18:18+19);
fact = 0.55;

rescorr = corrdc(blod, pattern);
threshcorr = rescorr>(max(rescorr(:))*fact);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(blod, [0 255]);
axis image; title('original image'); colorbar;
subplot(2,2,2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2,2,3), imagesc(rescorr);
axis image; title('result corr'); colorbar;
subplot(2,2,4), imagesc(threshcorr);
axis image; title('thresh corr'); colorbar;


S = bwmorph(threshcorr,'shrink',Inf);
figure(2); imagesc(S);
disp(['Blood Cells:  ', num2str(sum(sum(S)))])

resultim = zeros(256,256,3);
resultim(:,:,1) = (threshcorr==1).*255+(threshcorr==0).*blod;
resultim(:,:,2) = blod;
resultim(:,:,3) = blod;
figure(99), imshow(resultim/255);