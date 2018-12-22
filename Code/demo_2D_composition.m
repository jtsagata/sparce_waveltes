clearvars
close all
clc 

name='lena';
n = 256;
level_d = 1;

f0=load_image(name);
f0 = rescale(crop(f0,n));

f0_r = f0(:,:,1);
f0_g = f0(:,:,2);
f0_b = f0(:,:,1);

fg1= figure('Name','Lena');
subplot(2,2,1); imageplot(f0);   title('lena');
subplot(2,2,2); imageplot(f0_r); title('red');
subplot(2,2,3); imageplot(f0_r); title('green');
subplot(2,2,4); imageplot(f0_r); title('blue');
suptitle('Lena and the RGB channels');
title('Lena');

% Define Haar filter
Ho=1/sqrt(2)*[1 +1];

wcR=fwt_or_2d(0,f0_r,level_d,Ho);
wcG=fwt_or_2d(0,f0_g,level_d,Ho);
wcB=fwt_or_2d(0,f0_b,level_d,Ho);
wcRGB = cat(3, wcR , wcG , wcB);

fg2= figure('Name','Comp lvl1');
subplot(2,2,1); imageplot(wcRGB);   title('lena');
subplot(2,2,2); imageplot(wcR); title('red');
subplot(2,2,3); imageplot(wcG); title('green');
subplot(2,2,4); imageplot(wcB); title('blue');

%figure; imageplot(wavelet_comp);