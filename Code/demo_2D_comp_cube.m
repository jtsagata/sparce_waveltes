clearvars
close all
clc 

name='rubik1';
n = 256;
level_d = 1;

f0=load_image(name);
f0 = rescale(crop(f0,n));

f0_r = f0(:,:,1);
f0_g = f0(:,:,2);
f0_b = f0(:,:,3);

% Define Haar filter
Ho=1/sqrt(2)*[1 +1];

% Do Wavelet composition
wcR=fwt_or_2d(0,f0_r,level_d,Ho);
wcG=fwt_or_2d(0,f0_g,level_d,Ho);
wcB=fwt_or_2d(0,f0_b,level_d,Ho);
wcRGB = cat(3, wcR , wcG , wcB);

fg2= figure('Name','Comp lvl1');
subplot(2,2,1); imageplot(wcRGB);   title('Rubik');
subplot(2,2,2); imageplot(wavelt_visible(wcR,level_d,n)); title('Enchanced Red');
subplot(2,2,3); imageplot(wavelt_visible(wcG,level_d,n)); title('Enchanced Green');
subplot(2,2,4); imageplot(wavelt_visible(wcB,level_d,n)); title('Enchanced Blue');
suptitle('Rubik Wavelet Composition (enchanched)')

% Calculate result png name and directory
p = mfilename('fullpath');
[filepath,name,ext]=fileparts(p);
imageFile=fullfile(filepath,'../Results/Rubik_Ench.png');
saveas(gcf,imageFile)


function [imgnorm] = wavelt_visible(channel, level,n)
    %n = size(channel,1);
    m = n/(2^level);

    % get the clen part
    img_clean = channel(1:m, 1:m);
    
    % Mask the image part
    channel(1:n/(2^level), 1:n/(2^level)) = 0;
    max_range=max(channel(:));
    channel = channel/max_range;
    channel(1:m, 1:m) = img_clean;
    imgnorm = channel;
end