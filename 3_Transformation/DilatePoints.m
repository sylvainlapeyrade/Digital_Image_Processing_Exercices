Im = zeros(64,64);
Im(20,20) = 1; Im(50,30) = 1; Im(25,50) = 1;
SE4 = [0 1 0; 1 1 1; 0 1 0];
SE8 = [1 1 1; 1 1 1; 1 1 1];

Im_d4 = imdilate(Im, SE4);
Im_d8 = imdilate(Im, SE8);

Im10_d4 = imdilate(Im_d4, SE4);
Im10_d8 = imdilate(Im_d8, SE8);

for i = 1:9
    Im10_d4 = imdilate(Im10_d4, SE4);
    Im10_d8 = imdilate(Im10_d8, SE8);
end

Im_oct = imdilate(Im_d4, SE4);
Im_oct = imdilate(Im_d8, SE8);

for i = 1:4
    Im_oct = imdilate(Im_oct, SE4);
    Im_oct = imdilate(Im_oct, SE8);
end

figure(1)
colormap(gray(256))
subplot(2,3,1), imagesc(Im);
axis image; title('Three points');
subplot(2,3,2), imagesc(Im_d4);
axis image; title('1 iter d4');
subplot(2,3,3), imagesc(Im_d8);
axis image; title('1 iter d8');
subplot(2,3,4), imagesc(Im10_d4);
axis image; title('10 iter d4');
subplot(2,3,5), imagesc(Im10_d8);
axis image; title('10 iter d8');
subplot(2,3,6), imagesc(Im_oct);
axis image; title('5 iter d4 & d8');