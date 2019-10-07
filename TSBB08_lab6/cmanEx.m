% Read original image;
im = double(imread('cmanmod.png'));

figure(1)
colormap(gray(256))
subplot(1,1,1); imagesc(im, [0 256]); colorbar;
axis image; axis off;

% Compute derivative images
dfx = [1 0 -1; 2 0 -2; 1 0 -1]/8; % sobelx
fx=conv2(im,dfx, 'valid'); % With valid you get rid of the dark frame
maxv = max(max(abs(fx)))/2;

figure(2)
colormap(gray(256))
subplot(1,2,1); imagesc(fx, [-maxv maxv]); colorbar('horizontal'); 
axis image; axis off;
title('f_x')

% fy
dfy =dfx';
fy=conv2(im,dfy,'valid');
maxw = max(max(abs(fy)))/2;

subplot(122); imagesc(fy,[-maxw,maxw]);colorbar('horizontal'); 
axis image; axis off;
title('f_y')

%%
% T11, T12, T22
T11 = fx.^2;
T12 = fx.*fy;
T21 = T12;
T22 = fy.^2;

T = [T11 T12; T21 T22];

figure(3)
colormap(gray(256))
subplot(1,2,1); imagesc(T11,[0,6500]); colorbar('horizontal'); 
axis image; axis off;
title('T_1_1 without LP')
% subplot(1,2,2); imagesc(T12,[0,6500]); colorbar('vertical'); 
% axis image; axis off;
% title('T_1_2 without LP')
subplot(1,2,2); imagesc(T22,[0,6500]);colorbar('horizontal'); 
axis image; axis off;
title('T_2_2 without LP')

%% LP filtering
sigma=1;
lpH=exp(-0.5*([-9:9]/sigma).^2);
lpH=lpH/sum(lpH); % Horizontal filter
lpV=lpH';         % Vertical filter

T11_LP = conv2(T11,lpH,'same');
T11_LP = conv2(T11_LP,lpV,'same');
T22_LP = conv2(T22,lpH,'same');
T22_LP = conv2(T22_LP,lpV,'same');

figure(4);colormap(gray(256));
subplot(121); imagesc(T11_LP,[0,2500]);colorbar('horizontal'); 
axis image; axis off;
title('T_1_1 with LP')
subplot(122); imagesc(T22_LP,[0,2500]);colorbar('horizontal'); 
axis image; axis off;
title('T_2_2 with LP')

%% Abs(z) and Arg(z)
T12_LP = conv2(T12,lpH, 'same');
T12_LP = conv2(T12_LP, lpV, 'same');
T21_LP = T12_LP;

z = T11_LP - T22_LP + 1i*2*T12_LP;
zg = fx + 1i*fy;
absz = abs(z);
argz = atan2(2*T12_LP,T11_LP-T22_LP);

[X,Y] = size(argz);
for y = 1: Y
    for x =1 :X
        if argz(y,x) < 0
            argz(y,x) = argz(y,x) + 2*pi;
        end
    end
end

figure(5);
subplot(121); imagesc(absz);colorbar('horizontal'); 
colormap(gray(256)); axis image; axis off;
title('abs(z)')
subplot(122); imagesc(argz);colorbar('horizontal'); 
colormap(goptab()); axis image; axis off;
title('arg(z)')

figure(6);
gopimage(z); axis off;