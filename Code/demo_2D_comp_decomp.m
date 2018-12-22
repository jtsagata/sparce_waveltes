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
f0_b = f0(:,:,3);

fg1= figure('Name','Lena');
subplot(2,2,1); imageplot(f0);   title('lena');
subplot(2,2,2); imageplot(f0_r); title('red');
subplot(2,2,3); imageplot(f0_r); title('green');
subplot(2,2,4); imageplot(f0_r); title('blue');
suptitle('Lena and the RGB channels');

% Define Haar filter
Ho=1/sqrt(2)*[1 +1];

% Do Wavelet composition
wcR=fwt_or_2d(0,f0_r,level_d,Ho);
wcG=fwt_or_2d(0,f0_g,level_d,Ho);
wcB=fwt_or_2d(0,f0_b,level_d,Ho);
wcRGB = cat(3, wcR , wcG , wcB);

fg2= figure('Name','Comp lvl1');
subplot(2,2,1); imageplot(wcRGB);   title('lena');
subplot(2,2,2); imageplot(wcR); title('red');
subplot(2,2,3); imageplot(wcG); title('green');
subplot(2,2,4); imageplot(wcB); title('blue');
suptitle('Lena Wavelet Composition')

% Do Wavelet decomposition
f_Rc=fwt_or_2d(1,wcR,level_d,Ho);
f_Gc=fwt_or_2d(1,wcG,level_d,Ho);
f_Bc=fwt_or_2d(1,wcB,level_d,Ho);
f_c = cat(3, f_Rc , f_Gc , f_Bc);

fg3= figure('Name','DeComp lvl1');
subplot(2,2,1); imageplot(f_c);   title('lena');
subplot(2,2,2); imageplot(f_Rc); title('red');
subplot(2,2,3); imageplot(f_Gc); title('green');
subplot(2,2,4); imageplot(f_Bc); title('blue')
suptitle('Lena Wavelet DeComposition')

% This must be close to zero
diff = abs(f0-f_c);
sum(diff(:))
