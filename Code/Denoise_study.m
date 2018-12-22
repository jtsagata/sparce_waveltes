clearvars
close all
clc 

% Parameters
name_fig1='lena';
name_fig2='boat';
n = 256;
level_d = 2;
level_d2 = 4;
noise_level=0.1;
theshold_type='hard';

image_name = 'leana_threshold';

% Define Daubechies filter
Ho=[326/675 1095/1309 648/2891 -675/5216];

% Load image
f  = load_image(name_fig1);
f  = rescale(crop(f,n));
f0 = f + noise_level*randn(size(f));

[f_hard,theSNR1] = Denoising(f0,level_d,Ho, 'hard');
[f_soft,theSNR2] = Denoising(f0,level_d,Ho, 'soft');
[f_stain,theSNR3] = Denoising(f0,level_d,Ho, 'stein');

fg1= figure('Name','Thresholding');
subplot(2,2,1); imageplot(f0, ['Noisy Image']);
subplot(2,2,2); imageplot(f_hard,  ['Hard SNR: ' num2str(theSNR1)]);
subplot(2,2,3); imageplot(f_soft,  ['Soft SNR: ' num2str(theSNR2)]);
subplot(2,2,4); imageplot(f_stain, ['StainSNR: ' num2str(theSNR3)]);
suptitle(['Thresholding with Daubechies, noise level ' num2str(noise_level)]);


% Create Images for presentation
% Calculate result png name and directory
p = mfilename('fullpath');
[filepath,name_fig1,ext]=fileparts(p);

imageFile=fullfile(filepath,'../Results/',[image_name,'.png']);
saveas(fg1,imageFile)

snr_hard=[];snr_soft=[];snr_stain=[];
for noise=0:0.1:1
    f0 = f + noise*randn(size(f));
    
    [f_hard,theSNR1] = Denoising(f0,level_d,Ho, 'hard');
    [f_soft,theSNR2] = Denoising(f0,level_d,Ho, 'soft');
    [f_stain,theSNR3] = Denoising(f0,level_d,Ho, 'stein'); 
    
    snr_hard(end+1)= theSNR1;
    snr_soft(end+1)= theSNR2;
    snr_stain(end+1)= theSNR3;
end


fg2 = figure; 
subplot(1,2,1); hold on
pbaspect([1 1 1])
plot(0:0.1:1, snr_hard, 'r', 'DisplayName','Hard thresholding')
plot(0:0.1:1, snr_soft, 'g', 'DisplayName','Soft thresholding')
plot(0:0.1:1, snr_stain, 'b', 'DisplayName','Stain thresholding')
xlabel(['Noise level with ' num2str(level_d) ' decomposition2']);
ylabel('SNR');
legend

snr_hard2=[];snr_soft2=[];snr_stain2=[];
for noise=0:0.1:1
    f0 = f + noise*randn(size(f));
    
    [f_hard,theSNR1] = Denoising(f0,level_d2,Ho, 'hard');
    [f_soft,theSNR2] = Denoising(f0,level_d2,Ho, 'soft');
    [f_stain,theSNR3] = Denoising(f0,level_d2,Ho, 'stein'); 
    
    snr_hard2(end+1)= theSNR1;
    snr_soft2(end+1)= theSNR2;
    snr_stain2(end+1)= theSNR3;
end

subplot(1,2,2); hold on
pbaspect([1 1 1])
plot(0:0.1:1, snr_hard2, 'r', 'DisplayName','Hard thresholding')
plot(0:0.1:1, snr_soft2, 'g', 'DisplayName','Soft thresholding')
plot(0:0.1:1, snr_stain2, 'b', 'DisplayName','Stain thresholding')
xlabel(['Noise level with ' num2str(level_d2) ' decompositions']);
ylabel('SNR');
legend

imageFile=fullfile(filepath,'../Results/',['noise_levels','.png']);
saveas(fg2,imageFile)
