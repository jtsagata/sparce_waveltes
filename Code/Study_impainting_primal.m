clearvars
close all
clc 
p = mfilename('fullpath');
[filepath,~,~]=fileparts(p);
n = 256;

lena_fname='lena';
f0=load_image(lena_fname);
f0 = rescale(crop(f0,n));


% Destroy
rho=0.7;
Lambda = rand(n,n)>rho;
Phi = @(f) f.*Lambda;
y=Phi(f0);

% Parameters
L=8;
sigma = 10;
tau = .9/(L*sigma);
theta = 1;


[repair1,tv_energy1]=ImpaintingPrimalDual(y(:,:,1),100, sigma, tau, theta, Phi);
[repair2,tv_energy2]=ImpaintingPrimalDual(y(:,:,2),100, sigma, tau, theta, Phi);
[repair3,tv_energy3]=ImpaintingPrimalDual(y(:,:,3),100, sigma, tau, theta, Phi);
repair=cat(3,repair1, repair2, repair3);


% Final comparison
fg1= figure('Name','Comparison');
subplot(1,3,1); imageplot(f0);    title('Original Image');
subplot(1,3,2); imageplot(y);     title('Damaged Image');
subplot(1,3,3); imageplot(repair); title('Impainting Image');

imageFile=fullfile(filepath,'../Results/Inpainting_pdual_lena.png');
saveas(fg1,imageFile)

fg2= figure('Name','Plots');hold on
p=plot([tv_energy1  tv_energy2  tv_energy3]);
legend(p,'R','G','B');
xlabel('Time step');ylabel('TV Energy');

imageFile=fullfile(filepath,'../Results/Inpainting_pdual_lena_evolution.png');
saveas(fg2,imageFile)


lena_snr = snr(f0, repair)

