clearvars
close all
clc 

% Parameters
name_fig1='lena';
n = 256;
theshold_type='hard';

% Define Daubechies filter
Ho=[326/675 1095/1309 648/2891 -675/5216];

% Load image
f  = load_image(name_fig1);
f  = rescale(crop(f,n));

% Create Images for presentation
p = mfilename('fullpath');
[filepath,name_fig1,ext]=fileparts(p);

snr1=[];snr2=[];snr4=[];snr8=[];snr16=[];
for noise=0.1:0.1:1
    f0 = f + noise*randn(size(f));
    
    [~,theSNR1] = Denoising(f0,1,Ho, 'hard');
    [~,theSNR2] = Denoising(f0,2,Ho, 'hard');
    [~,theSNR4] = Denoising(f0,4,Ho, 'hard');
    [~,theSNR8] = Denoising(f0,8,Ho, 'hard');
    [~,theSNR16] = Denoising(f0,8,Ho, 'hard');

    
    snr1(end+1)= theSNR1;
    snr2(end+1)= theSNR2;
    snr4(end+1)= theSNR4;
    snr8(end+1)= theSNR8;
    snr16(end+1)= theSNR16;
end


fg2 = figure; hold on;
pbaspect([1 1 1])
plot(0.1:0.1:1, snr1, 'r', 'DisplayName','1 level')
plot(0.1:0.1:1, snr2, 'g', 'DisplayName','2 levels')
plot(0.1:0.1:1, snr4, 'b', 'DisplayName','4 levels')
plot(0.1:0.1:1, snr8, 'Color', [1 0 1], 'DisplayName','8 levels')
plot(0.1:0.1:1, snr16, 'Color', [1 1 0], 'DisplayName','16 levels')
xlabel('Noise level');
ylabel('SNR');
legend

imageFile=fullfile(filepath,'../Results/',['noise_levels_vs_d','.png']);
saveas(fg2,imageFile)
