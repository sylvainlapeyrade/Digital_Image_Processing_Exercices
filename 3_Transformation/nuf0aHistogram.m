binvect = [0:1:255];

load nuf0a.mat
histo = hist(nuf0a(:), binvect);
nuf0aT = (nuf0a<130);

SE4 = [0 1 0; 1 1 1; 0 1 0];
SE8 = [1 1 1; 1 1 1; 1 1 1];

% nuf0aT_d4 = imdilate(nuf0aT, SE4);
% nuf0aT_d8 = imdilate(nuf0aT, SE8);
% nuf0aT_de4 = imerode(nuf0aT_d4, SE4);
% nuf0aT_de8 = imerode(nuf0aT_d8, SE8);


nuf0aT_d4 = imdilate(nuf0aT_d4, SE4);
nuf0aT_d8 = imdilate(nuf0aT_d8, SE8);
nuf0aT_de4 = imerode(nuf0aT_d4, SE4);
nuf0aT_de8 = imerode(nuf0aT_d8, SE8);

nuf0aT_de4 = imerode(nuf0aT_de4, SE4);
nuf0aT_de8 = imerode(nuf0aT_de8, SE8);
nuf0aT_d4 = imdilate(nuf0aT_de4, SE4);
nuf0aT_d8 = imdilate(nuf0aT_de8, SE8);




figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(nuf0a, [0 255]);
axis image; title('light image'); colorbar
subplot(2,2,2), plot(binvect, histo, '.-b');
axis tight; title('light histogram');

subplot(2,2,3), imagesc(nuf0aT);
axis image; title('Dark image'); colorbar

figure(2)
colormap(gray(256))
% subplot(2,2,1), imagesc(nuf0aT_d4);
% axis image; title('nuf0aTd4'); colorbar
% subplot(2,2,2), imagesc(nuf0aT_d8);
% axis image; title('nuf0aTd8'); colorbar
subplot(2,2,1), imagesc(nuf0aT_de4);
axis image; title('nuf0aTde4'); colorbar
subplot(2,2,2), imagesc(nuf0aT_de8);
axis image; title('nuf0aTde8'); colorbar