im = double(imread('polyg.tif'));

sobelx = [1 0 -1; 2 0 -2; 1 0 -1] /8;
Imsobelx = conv2(im, sobelx, 'same');
sobely = sobelx';
Imsobely = conv2(im, sobely, 'same');
Imgrad = sqrt(Imsobelx.^2+Imsobely.^2);
maxv = max(Imgrad(:));
binvect = [0:maxv/100:maxv];
histo = hist(Imgrad(:), binvect);

T=0.4;
cannyim2 = edge (im, 'canny', [0.4*T T]);
ImgradT = cannyim2;
Imskel = bwmorph(ImgradT, 'skel', inf);

figure(1)
colormap(gray(256))
subplot(2,2,1), imagesc(im, [0 255])
axis image; axis off; title('image'); colorbar;
subplot(2,2,2), imagesc(Imgrad)
axis image; axis off; title('magngrad'); colorbar;
subplot(2,2,3), plot(binvect, histo, '.-b');
axis tight; title('histogram')
subplot(2,2,4), imagesc(ImgradT)
axis image; axis off; title('threshholded'); colorbar;

figure(2)
colormap(gray(256))
subplot(1,1,1), imagesc(Imskel)
axis image; axis off; title('skeleton'); colorbar;

figure(3)
subplot(2,2,1), imagesc(Imskel);
axis image; axis xy; colorbar;
title('Image'),

% Call the Hough transform 
% ======================== 
[H,T,R] = hough(Imskel, 'Theta', -90:89);
subplot(2,2,2), imagesc(T,R,H);
xlabel('\theta'), ylabel('\rho');
title('Hough transform'), colorbar;

% Detect peaks
% ============
P = houghpeaks(H,10,'threshold',ceil(0.5*max(H(:))))
x = T(P(:,2)); y = R(P(:,1));
hold on
plot(x,y,'s','color','red'), hold off

% Inverse Hough transform give Hough lines
% ========================================
%lines = houghlines(ones(size(Imskel)),T,R,P);
lines = houghlines(imdilate(Imskel,ones(5)),T,R,P,'FillGap', 20,'MinLength', 100);

% Overlay Hough lines on image 
% ============================ 
subplot(2,2,3), imagesc(Imskel), hold on
title('Result'),axis image; axis xy; colorbar;

for k = 1:length(lines)
    xy = [lines(k).point1; 
        lines(k).point2];
    plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
end
hold off