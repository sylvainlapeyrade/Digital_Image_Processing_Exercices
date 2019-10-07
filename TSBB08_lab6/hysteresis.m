nuf = double(imread('nuf0c.tif'));
binvect = [0:1:255];
histo = hist(nuf(:), binvect);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(nuf, [0 255]); axis image;
title('image nuf0c'); colorbar
subplot(2,2,2), plot(binvect, histo, '.-b'); axis tight;
title('histogram')

thresh_nuf_1 = nuf > 145;
subplot(2,2,3), imagesc(thresh_nuf_1);
axis image; title('after threshold 1'); colorbar

thresh_nuf_2 = nuf > 106;
subplot(2,2,4), imagesc(thresh_nuf_2);
axis image; title('after threshold 2'); colorbar

figure(2);
colormap(gray(256));
while 1
    original_threshnuf1 = thresh_nuf_1;
    SE8 = ones(3,3);
    imdilated = imdilate(thresh_nuf_1, SE8);
    thresh_nuf_1 = imdilated .* thresh_nuf_2;

    imagesc(thresh_nuf_1);
    pause;
    if thresh_nuf_1 == original_threshnuf1
        break;
    end
end