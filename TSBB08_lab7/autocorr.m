%f = double(imread('skylt.tif'));
%f = double(imread('baboon256.tif'));
f = double(imread('foppa.tif'));

% Autocorrelation function
f = f - mean(mean(f));

fourrier_f = fftshift(fft2(ifftshift(f)));

Sf = abs(fourrier_f).^2;
rev_f = fftshift(ifft2(ifftshift(Sf)));

figure(1);
mesh(rev_f); % draws a wireframe mesh with color

% Calculation of Rho
[~,X] = max(max(rev_f));
rhox = rev_f(X,X+1)/rev_f(X,X);
rhoy = rev_f(X+1,X)/rev_f(X,X);

rho = (rhox + rhoy)/2