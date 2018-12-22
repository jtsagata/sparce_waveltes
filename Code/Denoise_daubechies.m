clearvars
close all
clc 

% Parameters
name='boat';
n = 256;
level_d = 1;
noise_level=0;
theshold_type='hard';

final_title = 'Hibiscus Denoising Example';
image_name = 'boat_hard_lvl1';

% Define Daubechies filter
Ho=[326/675 1095/1309 648/2891 -675/5216];

% Load image
f  = load_image(name);
f  = rescale(crop(f,n));
f0 = f + noise_level*randn(size(f));


% Split RGB channels
f0_r = f0(:,:,1); f0_g = f0(:,:,2); f0_b = f0(:,:,3);


fg1= figure('Name','Lena');
subplot(2,2,1); imageplot(f0);   title('lena');
subplot(2,2,2); imageplot(f0_r); title('red');
subplot(2,2,3); imageplot(f0_r); title('green');
subplot(2,2,4); imageplot(f0_r); title('blue');
suptitle('Noise Lena and the RGB channels')




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
suptitle('Lena Daubechies Composition without thersholding')


%##
%## Denoising
%## (TODO make a funcion)

% get the image parts (for restoration)
wavelet_image_R = wcR(1:n/(2^level_d), 1:n/(2^level_d));
wavelet_image_G = wcG(1:n/(2^level_d), 1:n/(2^level_d));
wavelet_image_B = wcB(1:n/(2^level_d), 1:n/(2^level_d));


% Get the thresholds
 tr_R = getThreshold(wcR,level_d);
 tr_G = getThreshold(wcG,level_d);
 tr_B = getThreshold(wcB,level_d);

 % Apply Thresholding
 wcR_t = perform_thresholding(wcR,tr_R,theshold_type);
 wcG_t = perform_thresholding(wcG,tr_R,theshold_type);
 wcB_t = perform_thresholding(wcB,tr_R,theshold_type);
 
 % Remove Thresholding on image part
 wcR_t(1:n/(2^level_d), 1:n/(2^level_d)) = wavelet_image_R;
 wcG_t(1:n/(2^level_d), 1:n/(2^level_d)) = wavelet_image_G;
 wcB_t(1:n/(2^level_d), 1:n/(2^level_d)) = wavelet_image_B;
 wcRGB_t = cat(3, wcR_t , wcG_t , wcB_t);

 
fg3= figure('Name','Comp thresh');
subplot(2,2,1); imageplot(wcRGB_t);   title('lena');
subplot(2,2,2); imageplot(wcR_t); title('red');
subplot(2,2,3); imageplot(wcG_t); title('green');
subplot(2,2,4); imageplot(wcB_t); title('blue');
suptitle('Lena Daubechies Composition with thersholding')

% Do Wavelet decomposition
f_Rc=fwt_or_2d(1,wcR_t,level_d,Ho);
f_Gc=fwt_or_2d(1,wcG_t,level_d,Ho);
f_Bc=fwt_or_2d(1,wcB_t,level_d,Ho);
f_c = cat(3, f_Rc , f_Gc , f_Bc);

fg4= figure('Name','DeComp lvl1');
subplot(2,2,1); imageplot(f_c);   title('lena');
subplot(2,2,2); imageplot(f_Rc); title('red');
subplot(2,2,3); imageplot(f_Gc); title('green');
subplot(2,2,4); imageplot(f_Bc); title('blue')
suptitle('Lena Daubechies DeComposition')


% Final comparison
fg5= figure('Name','Comparison');
subplot(1,2,1); imageplot(f0);   title('Noisy Image');
subplot(1,2,2); imageplot(f_c); title('Denoised Image');
%suptitle(final_title);

lena_snr = snr(f0, f_c)


% Create Images for presentation
% Calculate result png name and directory
p = mfilename('fullpath');
[filepath,name,ext]=fileparts(p);

imageFile=fullfile(filepath,'../Results/',[image_name,'.png']);
saveas(fg5,imageFile)

