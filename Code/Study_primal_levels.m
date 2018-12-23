clearvars
close all
clc 

% Basic setup
p = mfilename('fullpath');
[filepath,~]=fileparts(p);
n = 256;

% Images
image='lena';
f0=load_image(image);
f0 = rescale(crop(f0,n));

% Parameters
L=8;
sigma = 10;
tau = .9/(L*sigma);
theta = 1;


ii=1;
fg1=figure;
snr_data=[];
for rho=0.1:0.1:0.9
    % Destroy
    Lambda = rand(n,n)>rho;
    Phi = @(f) f.*Lambda;    
    y=Phi(f0);
    
    [repair1,~]=ImpaintingPrimalDual(y(:,:,1),100, sigma, tau, theta, Phi);
    [repair2,~]=ImpaintingPrimalDual(y(:,:,2),100, sigma, tau, theta, Phi);
    [repair3,~]=ImpaintingPrimalDual(y(:,:,3),100, sigma, tau, theta, Phi);
    repair=cat(3,repair1, repair2, repair3);

    subplot(3,3,ii); imageplot(repair); title(['ρ=' num2str(rho)]);
    snr_data(end+1)=snr(f0,repair);
    ii= ii +1;
end

imageFile=fullfile(filepath,'../Results/Inpainting_lena_noise_levels.png');
saveas(fg1,imageFile)

fg2=figure;
plot(0.1:0.1:0.9,snr_data)
xlabel('Damage level');
ylabel('SNR');
title('SNR restoration vs noise level');

imageFile=fullfile(filepath,'../Results/Inpainting_lena_noise_vs_SNR.png');
saveas(fg2,imageFile);
