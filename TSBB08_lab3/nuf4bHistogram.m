binvect = [0:1:255];

load nuf4b.mat
histo = hist(nuf4b(:), binvect);
nuf4bT = (nuf4b<135);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(nuf4b, [0 255]);
axis image; title('light image'); colorbar
subplot(2,2,2), plot(binvect, histo, '.-b');
axis tight; title('light histogram');

subplot(2,2,3), imagesc(nuf4bT);
axis image; title('Dark image'); colorbar