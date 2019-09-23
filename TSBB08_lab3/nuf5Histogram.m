binvect = [0:1:255];

load nuf5.mat
histo = hist(nuf5(:), binvect);
nuf5T = (nuf5<182);

SE4 = [0 1 0; 1 1 1; 0 1 0];
SE8 = [1 1 1; 1 1 1; 1 1 1];

nuf5T_d4 = imdilate(nuf5T, SE4);
nuf5T_d8 = imdilate(nuf5T, SE8);
nuf5T_de4 = imerode(nuf5T_d4, SE4);
nuf5T_de8 = imerode(nuf5T_d8, SE8);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(nuf5, [0 255]);
axis image; title('light image'); colorbar
subplot(2,2,2), plot(binvect, histo, '.-b');
axis tight; title('light histogram');

subplot(2,2,3), imagesc(nuf5T);
axis image; title('Dark image'); colorbar

% figure(2)
% colormap(gray(256))
% subplot(2,2,1), imagesc(nuf5T_d4);
% axis image; title('nuf5Td4'); colorbar
% subplot(2,2,2), imagesc(nuf5T_d8);
% axis image; title('nuf5Td8'); colorbar
% subplot(2,2,3), imagesc(nuf5T_de4);
% axis image; title('nuf5Tde4'); colorbar
% subplot(2,2,4), imagesc(nuf5T_de8);
% axis image; title('nuf5Tde8'); colorbar