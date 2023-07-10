Im = zeros(64,64);
Im(20,20) = 1;
Im(50,30) = 1;
Im(25,50) = 1;

figure(1)
colormap(colorcube(51))
subplot(2,2,1), imagesc(Im);
axis image; title('Three points'); colorbar
Im_eq = bwdist(Im);
subplot(2,2,2), imagesc(Im_eq, [0 50]);
axis image; title('Euclidian'); colorbar
Im_eq_cityblock = bwdist(Im, 'cityblock');
subplot(2,2,3), imagesc(Im_eq_cityblock, [0 50]);
axis image; title('cityblock'); colorbar
Im_eq_chessboard = bwdist(Im, 'chessboard');
subplot(2,2,4), imagesc(Im_eq_chessboard, [0 50]);
axis image; title('chessboard'); colorbar

ImD = imread('distObject.tif');
figure(2)
colormap(colorcube(51))
subplot(2,2,1), imagesc(ImD);
axis image; title('distObject'); colorbar
Imd_inside = bwdist(~ImD);
subplot(2,2,2), imagesc(Imd_inside);
axis image; title('distMap in Object'); colorbar
