binvect = [0:1:255];

load nuf4b.mat
histo = hist(nuf4b(:), binvect);

nuf4bT = (nuf4b<130);

nuf4bT_skel = bwmorph(nuf4bT,'skel', Inf);
nuf4bT_skel2 = bwskel(nuf4bT);
nuf4bT_pruning = bwmorph(nuf4bT,'shrink', 7);

m = [0 0 0; 0 1 0; 1 0 0];
endPoint = imerode(nuf4bT_pruning, m) & imerode(~nuf4bT_pruning, ~m);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(nuf4b, [0 255]);
axis image; title('light image'); colorbar
%subplot(2,2,2), imagesc(nuf4bT);
%axis image; title('Dark image'); colorbar
subplot(2,2,2), imagesc(nuf4bT_skel);
axis image; title('nuf4bTskel'); colorbar
subplot(2,2,3), imagesc(nuf4bT_skel2);
axis image; title('bwskel image'); colorbar
subplot(2,2,4), imagesc(nuf4bT_pruning);
axis image; title('nuf4bTpruning'); colorbar

figure(2)
colormap(gray(256))
subplot(1,2,1), imagesc(endPoint);
axis image; title('End point'); colorbar

[y, x] = find(endPoint);
[yout, xout] = track10(nuf4bT_pruning, y, x)
rad2deg(atan2(yout-y,xout-x))
