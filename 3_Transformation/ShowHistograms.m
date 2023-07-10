binvect = [0:1:255];

load clic.mat
histo = hist(clic(:), binvect);
figure(1)
colormap(gray(256))
subplot(2,1,1), imagesc(clic, [0 255]);
axis image; title('light image'); colorbar
subplot(2,1,2), plot(binvect, histo, '.-b');
axis tight; title('histogram');


load blod256.mat
histo2 = hist(blod256(:), binvect);
figure(2)
colormap(gray(256))
subplot(2,1,1), imagesc(blod256, [0 255]);
axis image; title('Dark image'); colorbar
subplot(2,1,2), plot(binvect, histo2, '.-b');
axis tight; title('histogram');

Im = double(imread('baboon.tif'));
histo3 = hist(Im(:), binvect);
figure(3)
colormap(gray(256))
subplot(2,1,1), imagesc(Im, [0 255]);
axis image; title('Dark image'); colorbar
subplot(2,1,2), plot(binvect, histo3, '.-b');
axis tight; title('histogram');

A = 1.7;
B = 85; 
ImT = A * Im - B;
histo4 = hist(ImT(:), binvect);
figure(4)
colormap(gray(256))
subplot(2,1,1), imagesc(ImT, [0 255]);
axis image; title('Dark image'); colorbar
subplot(2,1,2), plot(binvect, histo4, '.-b');
axis tight; title('histogram');
