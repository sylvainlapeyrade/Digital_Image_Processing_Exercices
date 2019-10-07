im = double(imread('blod256.tif'));
pattern = im(26:26+19, 19:19+19);
fact = 0.50;

% Common correlation
rescorr = corr(im, pattern);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2,2,2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2,2,3), imagesc(rescorr);
axis image; title('result corr'); colorbar;
subplot(2,2,4), imagesc(rescorr>(max(rescorr(:))*fact));
axis image; title('thresh corr'); colorbar;

% Normalized correlation
normcorr = corrn(im, pattern);

figure(2)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2,2,2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2,2,3), imagesc(normcorr);
axis image; title('result normcorr'); colorbar;
subplot(2,2,4), imagesc(normcorr>(max(normcorr(:))*fact));
axis image; title('thresh normcorr'); colorbar;

% Correlation without local DC-level
corrWDC = corrdc(im, pattern);

figure(3)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2,2,2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2,2,3), imagesc(corrWDC);
axis image; title('result corrWDC'); colorbar;
subplot(2,2,4), imagesc(corrWDC>(max(corrWDC(:))*fact));
axis image; title('thresh corrWDC'); colorbar;

% Normalized correlation without local DC-level
normcorrWDC = corrc(im, pattern);

figure(4)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255]);
axis image; title('original image'); colorbar;
subplot(2,2,2), imagesc(pattern, [0 255]);
axis image; title('pattern'); colorbar;
subplot(2,2,3), imagesc(normcorrWDC);
axis image; title('result normcorrWDC'); colorbar;
subplot(2,2,4), imagesc(normcorrWDC>(max(normcorrWDC(:))*fact));
axis image; title('thresh normcorrWDC'); colorbar;