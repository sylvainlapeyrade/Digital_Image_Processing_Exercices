load peppersmall
im = peppersmall;
aver = [1 2 1; 2 4 2; 1 2 1]/16;
aver3 = conv2(conv2(aver,aver,'full'),aver,'full');
half = (size(im,1)-1)/2;
[u,v] = meshgrid(-ceil(half):floor(half),-ceil(half):floor(half));
IDEALFILT = sqrt(u.^2+v.^2) < 15;
%imconv = conv2(im,aver3,'same');
aver3im = 0*im;
center = size(im,1)/2+1;
aver3im(center-3:center+3, center-3:center+3) = aver3;
IM = fftshift(fft2(ifftshift(im)));
AVER3IM = fftshift(fft2(ifftshift(aver3im)));
% IMCONV = fftshift(fft2(ifftshift(imconv)));
IMCONV = IM .* IDEALFILT;
imconv = fftshift(ifft2(ifftshift(IMCONV)));
maxIM = max(max(abs(IM)));
figure(3); colormap gray;
subplot(131); imagesc(im);
axis image; title('im'); colorbar('SouthOutside')
subplot(132); imagesc(aver3im);
axis image; title('aver3im'); colorbar('SouthOutside')
subplot(133); imagesc(imconv);
axis image; title('imconv'); colorbar('SouthOutside')
figure(4); colormap gray;
subplot(131); imagesc(abs(IM), [0 0.01*maxIM]);
axis image; title('abs(F[im])'); colorbar('SouthOutside')
subplot(132); imagesc(abs(AVER3IM));
axis image; title('abs(F[aver3im])'); colorbar('SouthOutside')
subplot(133); imagesc(abs(IMCONV), [0 0.01*maxIM]);
axis image; title('abs(F[imconv])'); colorbar('SouthOutside')