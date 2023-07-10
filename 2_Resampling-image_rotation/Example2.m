Im = double(imread('logo.tif')); % load image;

% Circurlar mask to avoid missing corners
[Ny, Nx] = size(Im);
N = min(min(Nx,Ny));
[x,y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), ...
-ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im = Im.* mask;

rotIm = rotateimage(Im, pi/6, 'nearest');
nIm = rotateimage(rotIm, -pi/6, 'nearest');

figure(1); colormap gray;
subplot(221); imagesc(Im); axis image; colorbar;
subplot(222); imagesc(rotIm); axis image; colorbar;
subplot(223); imagesc(nIm); axis image; colorbar;
% Different-image
subplot(224); imagesc(nIm-Im); axis image; axis image; colorbar;
% Calculate error-energy
sum(sum((nIm-Im).*(nIm-Im)))

fIm = fftshift(fft2(ifftshift(Im)));
frotIm = fftshift(fft2(ifftshift(rotIm)));
fnIm = fftshift(fft2(ifftshift(nIm)));

figure(2); colormap gray;
subplot(221); imagesc(log(1+abs(fIm))); axis image; colorbar;
subplot(222); imagesc(log(1+abs(frotIm))); axis image; colorbar;
subplot(223); imagesc(log(1+abs(fnIm))); axis image; colorbar;
% Relative error-image
subplot(224); imagesc(log(1+abs(fnIm-fIm))); axis image; axis image; colorbar;
% Calculate error-energy for fourier
N = size(fIm);
sum(sum((fIm-fnIm).*conj(fIm-fnIm)))/(N(1)*N(2))

figure(3); colormap gray;
imagesc(abs(fIm-fnIm)./abs(fIm),[0 2]); axis image; colorbar;
% Relative error in Fourier transform
sum(sum(abs(fIm-fnIm)/abs(fIm)))

rotImBi = rotateimage(Im, pi/6, 'bilinear');
nImBi = rotateimage(rotImBi, -pi/6, 'bilinear');

% Bilinear interpolation
figure(4); colormap gray;
subplot(221); imagesc(Im); axis image; colorbar;
subplot(222); imagesc(rotImBi); axis image; colorbar;
subplot(223); imagesc(nImBi); axis image; colorbar;
% Image difference
subplot(224); imagesc(nImBi-Im); axis image; colorbar;
% Calculate error-energy for bilinear
sum(sum((nImBi-Im).*(nImBi-Im)))

frotImBi = fftshift(fft2(ifftshift(rotIm)));
fnImBi = fftshift(fft2(ifftshift(nImBi)));

% Bilinear in Fourier Domain
figure(5); colormap gray;
subplot(221); imagesc(log(1+abs(fIm))); axis image; colorbar;
subplot(222); imagesc(log(1+abs(frotImBi))); axis image; colorbar;
subplot(223); imagesc(log(1+abs(fnImBi))); axis image; colorbar;
% Relative error image
subplot(224); imagesc(abs(fIm-fnImBi)./abs(fIm),[0 2]); axis image; axis image; colorbar;

% Bicubic4 interpolation
rotImbi4 = rotateimage(Im, pi/6, 'bicubic');
nImbi4 = rotateimage(rotImbi4, -pi/6, 'bicubic');
frotImBi4 = fftshift(fft2(ifftshift(rotImbi4)));
fnImBi4 = fftshift(fft2(ifftshift(nImbi4)));

figure(6); colormap gray;
subplot(221); imagesc(Im); axis image; colorbar;
subplot(222); imagesc(rotImbi4); axis image; colorbar;
subplot(223); imagesc(nImbi4); axis image; colorbar;
% Relative error image
%subplot(224); imagesc(abs(fIm-fnImBi4)./abs(fnImBi4), [0 2]); axis image; axis image; colorbar;
subplot(224); imagesc(nImbi4-Im); axis image; axis image; colorbar;
% Calculate error-energy
sum(sum((nImbi4-Im).*(nImbi4-Im)))

% Bicubic16 interpolation
rotImbi16 = rotateimage(Im, pi/6, 'bicubic16');
nImbi16 = rotateimage(rotImbi16, -pi/6, 'bicubic16');
frotImBi16 = fftshift(fft2(ifftshift(rotImbi16)));
fnImBi16 = fftshift(fft2(ifftshift(nImbi16)));

figure(7); colormap gray;
subplot(221); imagesc(Im, [0 1]); axis image; colorbar;
subplot(222); imagesc(log(1+abs(frotImBi16))); axis image; colorbar;
subplot(223); imagesc(log(1+abs(fnImBi16))); axis image; colorbar;
% Relative error image
subplot(224); imagesc(abs(fnImBi16-fIm)./abs(fIm)); axis image; axis image; colorbar;
% Calculate error-energy
sum(sum((nImbi16-Im).*(nImbi16-Im)))

Im2 = double(imread('baboon.tif')); % load image
theta = pi/6.1;

[Ny, Nx] = size(Im2);
N = min(min(Nx,Ny));
[x, y] = meshgrid(-ceil((Nx-1)/2):floor((Nx-1)/2), -ceil((Ny-1)/2):floor((Ny-1)/2));
mask = (x.^2 + y.^2)<((N-1)/2)^2;
Im2 = Im2.* mask;

rotImBicub16 = rotateimage(Im2,theta,'bicubic16');
rotImBilin = rotateimage(Im2,theta,'bilinear');
rotImNN = rotateimage(Im2,theta,'nearest');

for i = 1:10
    rotImBicub16 = rotateimage(rotImBicub16,theta,'bicubic16');
    rotImBilin = rotateimage(rotImBilin,theta,'bilinear');
    rotImNN = rotateimage(rotImNN,theta,'nearest');
end

figure(8); colormap gray;
subplot(221); imagesc (Im2); axis image; colorbar;
title('Original');
subplot(222); imagesc (rotImNN); axis image; colorbar;
title('RotImNN');
subplot(223); imagesc (rotImBilin); axis image; colorbar;
title('RotImBilinear');
subplot(224); imagesc (rotImBicub16); axis image; colorbar;
title('RotImBicubic16');

Im3 = double(imread('logo.tif'));
[Ny, Nx] = size(Im3);
N = min(min(Nx,Ny));

